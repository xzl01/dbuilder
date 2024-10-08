#!/bin/bash

# 确保脚本接收一个文件名作为参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_packages_file>"
    exit 1
fi

# 获取文件路径
packages_file="$1"
log_file="push_packages.log"

# 检查文件是否存在
if [ ! -f "$packages_file" ]; then
    echo "File not found: $packages_file"
    exit 1
fi

# 创建或清空日志文件
: > "$log_file"

# 读取文件并处理每一行
while IFS= read -r package; do
    # 检查行是否为空
    if [ -n "$package" ]; then
        echo "Pushing package: $package" | tee -a "$log_file"
        
        # 执行推送命令并记录输出
        if ../dbuilder/dbuilder hub push "$package" >> "$log_file" 2>&1; then
            echo "Successfully pushed: $package" | tee -a "$log_file"
        else
            echo "Failed to push: $package" | tee -a "$log_file"
        fi
    fi
done < "$packages_file"

echo "All packages have been processed. Check $log_file for details."
