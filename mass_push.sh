#!/bin/bash

# 确保脚本接收两个参数：文件名和操作类型
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_packages_file> <action>"
    echo "Actions: push, pre"
    exit 1
fi

# 获取文件路径和操作类型
packages_file="$1"
action="$2"
log_file="process_packages.log"

if [[ "$1" == "--help" ]]; then
    echo "用法: $0 <软件包文件路径> <操作类型>"
    echo "操作类型: push, pre"
    echo ""
    echo "此脚本处理文件中的软件包列表。"
    echo "  push: 推送软件包到远程仓库。"
    echo "  pre : 预处理软件包。"
    echo ""
    echo "示例:"
    echo "  $0 packages.txt push  # 推送软件包"
    echo "  $0 packages.txt pre   # 预处理软件包"
    exit 0
fi


# 检查文件是否存在
if [ ! -f "$packages_file" ]; then
    echo "File not found: $packages_file"
    exit 1
fi

# 检查操作类型是否正确
if [[ "$action" != "push" && "$action" != "pre" ]]; then
    echo "Invalid action: $action. Use 'push' or 'pre'."
    exit 1
fi

# 创建或清空日志文件
: > "$log_file"

# 读取文件并处理每一行
while IFS= read -r package; do
    # 检查行是否为空
    if [ -n "$package" ]; then
        echo "Processing package: $package" | tee -a "$log_file"
        
        # 根据操作类型执行相应命令
        if [ "$action" == "push" ]; then
            if ../dbuilder/dbuilder hub push "$package" >> "$log_file" 2>&1; then
                echo "Successfully pushed: $package" | tee -a "$log_file"
            else
                echo "Failed to push: $package" | tee -a "$log_file"
            fi
        elif [ "$action" == "pre" ]; then
            if ../dbuilder/dbuilder source pre "$package" >> "$log_file" 2>&1; then
                echo "Successfully pre-processed: $package" | tee -a "$log_file"
            else
                echo "Failed to pre-process: $package" | tee -a "$log_file"
            fi
        fi
    fi
done < "$packages_file"

echo "All packages have been processed. Check $log_file for details."
