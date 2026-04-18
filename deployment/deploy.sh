#!/bin/bash

echo "================================"
echo "EVE AI 部署脚本"
echo "================================"

export COMPOSE_PROJECT_NAME=eve

echo "[1/5] 创建必要的目录..."
mkdir -p ../logs ../data/mongodb ../data/redis

echo "[2/5] 检查Docker环境..."
if ! command -v docker &> /dev/null; then
    echo "错误: Docker未安装"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "错误: Docker Compose未安装"
    exit 1
fi

echo "[3/5] 创建环境变量文件..."
if [ ! -f .env ]; then
    cat > .env << EOF
JWT_SECRET=$(openssl rand -hex 32)
ENCRYPTION_KEY=$(openssl rand -hex 32)
ENCRYPTION_IV=$(openssl rand -hex 16)
EOF
    echo ".env文件已创建"
fi

echo "[4/5] 启动所有服务..."
docker-compose up -d

echo "[5/5] 等待服务启动..."
sleep 10

echo ""
echo "================================"
echo "服务状态:"
docker-compose ps
echo ""
echo "访问地址:"
echo "  - 前端应用: http://localhost:8080"
echo "  - 管理后台: http://localhost:5173"
echo "  - 后端API: http://localhost:3000"
echo "  - AI内核: http://localhost:8000"
echo ""
echo "================================"
echo "部署完成!"
echo ""
echo "常用命令:"
echo "  查看日志: docker-compose logs -f [service]"
echo "  停止服务: docker-compose down"
echo "  重启服务: docker-compose restart [service]"
echo "================================"
