#!/bin/zsh

# 弹出文件选择对话框让用户选择.app应用
app_path=$(osascript <<EOD
set appFile to (choose file of type {"APP"} with prompt "请选择要处理的应用程序")
POSIX path of appFile
EOD
)

# 检查用户是否选择了文件
if [ -z "$app_path" ]; then
    echo "未选择应用程序，操作已取消。"
    exit 1
fi

# 去除路径可能存在的引号（处理包含空格的路径）
cleaned_path=$(echo $app_path | sed "s/'//g")

# 执行权限修改命令
echo "正在处理应用程序：$cleaned_path"
xattr -r -d com.apple.quarantine "$cleaned_path"

# 检查执行结果
if [ $? -eq 0 ]; then
    echo "✅ 操作成功完成！"
else
    echo "❌ 操作执行失败，请检查权限和路径是否正确。"
fi
