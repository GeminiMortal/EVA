#!/bin/bash

# 虚拟女友人格系统 - GitHub 推送脚本
echo "🚀 准备推送虚拟女友人格系统到 GitHub..."

# 确保在正确的目录
cd "$(dirname "$0")"

# 添加所有文件
git add .

# 检查是否有更改需要提交
if ! git diff --cached --quiet; then
    echo "📝 提交更改..."
    git commit -m "feat: complete virtual girlfriend personality system with FastAPI backend"
else
    echo "✅ 没有新更改需要提交"
fi

# 推送到 GitHub
echo "📤 推送到 GitHub 仓库..."
git push origin main

echo "🎉 推送完成！"
echo "🔗 你的仓库地址: https://github.com/GeminiMortal/EVA.git"