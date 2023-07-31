#!/usr/bin/pytho3n


import requests
import parsel
import os
import subprocess
import shutil
import re
from time import sleep


base_url = "https://packages.debian.org"
save_source_path="/home/bluesky/packages"
version_url = f"{base_url}/trixie"
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
}

font_color = {
    'None': "\033[0m",    # 重置
    'red': "\033[31m",    # 错误提示
    'green': "\033[32m",  # 日志输出
    'yellow': "\033[33m", # 一般信息
    'blue': "\033[34m",   # 提示输入
}


class Node:
    def __init__(self, id: str, package_name: str):
        self.data = {
            "id": id,
            "text": package_name
        }
        self.children = []

    def get(self):
        return {
            "data": self.data,
            "children": self.children
        }


def find_and_append(data, old_text, node):
    if data["data"]["text"] == old_text:
        data["children"].append(node.get())
    else:
        for child in data["children"]:
            find_and_append(child, old_text, node)


def set_font_color(color: str, text: str) -> str:
    return f"{font_color[color]}{text}{font_color['None']}"


def catch_package(package: str) -> dict:
    data = {}
    url = f"{version_url}/{package}"
    response = requests.get(url=url, headers=headers)
    selector = parsel.Selector(response.text)

    psource = selector.css('#psource a::text').get()
    description = selector.css('#pdesc h2::text').get()
    try:
        purl = selector.css('#pmoreinfo ul')[1].css("li a::attr(href)")[0].get()
    except IndexError as e:
        purl = ""
        print(set_font_color("red", f"{package} 已经不存在"))

    data["package"] = package
    data["psource"] = psource
    data["description"] = description
    data["purl"] = purl
    return data


# 下载源码文件
def download_source_file(url: str) -> str:
    file_name = url.split("/")[-1]  # 获取dsc文件名
    source_name = url.split("/")[-2]  # 获取源码名
    out_path = os.path.join(save_source_path, source_name)
    # 返回源码包文件的路径，假设在当前目录下
    file_path = os.path.join(out_path, file_name)
    # 不存在目录则创建
    if not os.path.exists(out_path):
        os.makedirs(out_path)
        # 使用subprocess模块来运行dget命令，用来下载源码包文件
        # 目录该版本dget不支持下载文件到指定路径
        subprocess.run(["dget", url])
        # 获取源码包文件的名称，根据url中的最后一部分
        files = os.listdir()
        for file in files:
            if file.endswith('.dsc') \
            or file.endswith('.gz') \
            or file.endswith('.xz') \
            or file.endswith('.bz2') \
            or file.endswith('.asc'):
                shutil.move(file, out_path)
    else:
        print(set_font_color("red", f"{file_path} 已经存在"))
    return file_path


# 定义一个函数，用来检测一个源码包文件的依赖，并返回一个列表
def check_build_dependencies(src_file):
    # 创建一个空列表，用来存储依赖包的名称
    dependencies = []
    # pattern列表，存放不同情况的。
    pattern_list = [r'依赖: (.*) 但是它将不会被安装', r'依赖: (.*) 但无法安装它', r'Depends: (.*) but it is not going to be installed', r'Depends: (.*) but it is not installable']
    repo_name = src_file.split("/")[-2]
    source_dir = os.path.dirname(src_file)
    unzip_dir = os.path.join(source_dir, repo_name)
    # 解压dsc文件到指定目录
    if not os.path.exists(unzip_dir):
        subprocess.run(["dpkg-source", "-x", src_file, repo_name], cwd=source_dir)
        print(set_font_color("yellow", "解压dsc文件"))
    # 调用build-dep计算依赖
    result = subprocess.run(['sudo', 'apt', 'build-dep', '.'], input='n\n', stdout=subprocess.PIPE, encoding='utf-8',
                            cwd=unzip_dir)
    output = result.stdout

    # 匹配不同的情况
    for pattern in pattern_list:
        matches = re.finditer(pattern, output)
        if matches:
            for match in matches:
                dependencies.append(match.group(1).split()[0].split(":")[0])

    print(set_font_color("yellow", dependencies))
    return dependencies


# 定义一个函数，用来循环检测一个源码包文件及其依赖包文件的依赖，并将它们记录下来到sqlite数据库中，并返回数据库连接对象和游标对象
def loop_check_build_dependencies(package_name):
    id = 0
    # 依赖树
    dep_tree = {}
    # 用来存储每个包及其依赖包的名称和文件路径
    packages = {}
    # 存放所有包的依赖关系，如
    """
        packages_deps = {
            "libcgi-formbuilder-perl": ['libcgi-ssi-perl', 'libcgi-session-perl'],
            "libcgi-ssi-perl": ['libhtml-simpleparse-perl'],
            "libcgi-session-perl": ['libcgi-simple-perl']
        }
    """
    # packages_deps = {}
    # 用来存储待检测的包文件路径
    queue = []

    # 爬取软件包的数据
    package_data = catch_package(package_name)
    # 下载源码文件
    dsc_file = download_source_file(package_data["purl"])

    packages[package_name] = dsc_file
    print(set_font_color("yellow", "packages: "), packages)
    # 将源码包文件路径添加到待检测列表中
    queue.append(package_name)

    # 循环检测，直到待检测列表为空为止
    while queue:
        # 从待检测列表中弹出第一个元素，当前要检测的包文件的名称
        current_name = queue.pop(0)
        # 获取当前要检测的包文件路径
        current_file = packages[current_name]
        # 检测当前要检测的包文件的依赖，并返回一个列表
        current_dependencies = check_build_dependencies(current_file)

        # 每生成一个节点，id加1
        id += 1
        node = Node(id, current_name)
        # 如果id为1,则是根节点
        if id == 1:
            dep_tree = node.get()

        # 打印当前要检测的包文件及其依赖信息
        # print(set_font_color("yellow", "depends: "), current_dependencies)
        # 遍历当前要检测的包文件的依赖列表中的每个元素，作为依赖包的名称
        for dep_name in current_dependencies:
            sleep(5)     
            # 如果依赖包的名称已经在字典中，说明已经检测过了，跳过本次循环
            if dep_name in packages:
                continue
            else:
                # 如果依赖包的名称不在字典中，说明还没有检测过，需要继续检测
                package_data = catch_package(dep_name)
                dsc_file = ""
                # url爬取到的话进行文件下载，
                if package_data["purl"]:
                    dsc_file = download_source_file(package_data["purl"])
            
            id += 1
            node = Node(id, dep_name)
            find_and_append(dep_tree, current_name, node)

            # 将当前要检测的包文件的名称和文件路径添加到字典中，作为键和值
            packages[dep_name] = dsc_file
            print(set_font_color("yellow", "packages: "), packages)
            # 将依赖包的文件名添加到待检测列表中，等待下一次循环检测
            queue.append(dep_name)


    result = {
        "root": dep_tree,
        "template": "default",
        "theme": "fresh-blue",
        "version": "1.4.43"
    }
    print(result)


data = catch_package("libayatana-appindicator3-1")
purl = data["purl"]
psource = data["psource"]

# print(data)
# print(download_source_file(""))
# print(check_build_dependencies("/home/bluesky/packages/ocaml-ctypes/ocaml-ctypes_0.20.1-1.dsc"))
print(loop_check_build_dependencies("libtesseract-dev"))