# 虚拟女友人格卡片系统

基于 Docker 的多用户人格切换系统，支持动态学习和人格适应。

## 🚀 快速开始

### 1. 克隆项目
```bash
git clone <your-repo-url>
cd virtual-gf-system
```

### 2. 配置环境变量
```bash
cp .env.example .env
# 编辑 .env 文件，设置安全的密码和密钥
nano .env
```

### 3. 启动服务
```bash
docker-compose up -d
```

### 4. 验证部署
```bash
# 检查容器状态
docker-compose ps

# 查看数据库日志
docker-compose logs db
```

## 🗃️ 数据库结构

- **users**: 用户信息
- **personality_cards**: 人格卡片（支持 JSONB 动态字段）
- **conversation_history**: 对话历史（用于机器学习）
- **personality_switches**: 人格切换日志

## 🔄 人格切换功能

- 支持手动切换人格
- 自动学习用户偏好
- 基于对话上下文的智能适应
- 多用户隔离，数据安全

## 🔧 开发说明

- 使用 PostgreSQL UUID 扩展
- JSONB 字段支持灵活的人格数据结构
- 预配置了性能优化索引
- 容器化部署，易于扩展

## 📝 下一步

1. 实现 FastAPI 后端服务
2. 集成 LLM 进行人格学习
3. 开发前端界面
4. 添加用户认证系统