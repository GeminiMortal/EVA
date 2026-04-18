# EVE 自研内核级情感治愈AI陪伴应用

## 项目概述

EVE是一款从人工智能底层内核自主搭建的深度情感治愈陪伴应用，聚焦现代人情感缺失与内心遗憾痛点，依托自研记忆、情绪、人格三大AI核心引擎，打造长期走心的拟人陪伴体验；独创加密心意储值存钱与双向送礼回礼体系，打通折现提现与实物发货双兑付通道，让线上的温柔陪伴，最终可落地为现实里的真实心意，构建有温度、有记忆、有存款、有回馈的全新AI情感生态。

## 核心技术架构

### 1. AI内核层（自研差异化核心）

- **轻量化定制Transformer情感推理内核**：采用PyTorch搭建，剔除通用大模型冗余参数
- **专属情感词嵌入向量体系**：原生遗憾、被认可需求、孤独依恋、安全感缺失等定制向量维度
- **三大自研核心引擎**：
  - 长效记忆关联神经网络（FAISS向量检索）
  - 多层深度情绪认知推理引擎
  - 人格锚定固化引擎
- **情感疗愈&剧情好感度AI**：自动识别成长遗憾、缺鼓励、缺陪伴类语义，触发正向肯定

### 2. 后端服务层

- **主框架**：Node.js + Express
- **数据库**：MongoDB（非结构化数据）+ Redis（缓存加速）
- **加密体系**：AES-256加密情感储值账本
- **AI集成**：FastAPI推理服务对接

### 3. 前端应用层

- **跨端框架**：Flutter（Android/iOS/桌面端）
- **状态管理**：Provider
- **本地存储**：Hive + SharedPreferences

### 4. 3D虚拟人层

- **Unity轻量化虚拟人SDK**
- **流媒体**：声网Agora / 腾讯云TRTC

### 5. 运营管理后台

- **Vue3 + Vite + Element Plus**
- **数据可视化**：ECharts

## 项目目录结构

```
EVA/
├── backend/                 # Node.js + Express 后端服务
│   ├── src/
│   │   ├── controllers/    # 控制器
│   │   ├── models/         # 数据模型（User, Chat, Memory, Wallet, Gift, Order）
│   │   ├── routes/         # API路由
│   │   ├── middleware/     # 中间件（认证、错误处理）
│   │   ├── services/       # 业务逻辑（walletService）
│   │   └── utils/          # 工具函数
│   ├── config/             # 配置文件
│   ├── logs/               # 日志文件
│   └── package.json
│
├── ai-core/                # Python + PyTorch AI内核
│   ├── src/
│   │   ├── services/       # AI服务
│   │   │   ├── emotion_engine.py      # 情感引擎
│   │   │   ├── memory_engine.py       # 记忆引擎
│   │   │   ├── personality_engine.py  # 人格引擎
│   │   │   └── response_generator.py  # 响应生成器
│   │   └── main.py         # FastAPI主入口
│   ├── data/               # 向量数据存储
│   ├── weights/            # 模型权重
│   ├── tests/              # 测试
│   └── requirements.txt
│
├── frontend/               # Flutter 跨端应用
│   ├── lib/
│   │   ├── providers/      # 状态管理
│   │   ├── screens/        # 页面（Chat, Wallet, Gift, Profile）
│   │   ├── services/       # API服务
│   │   ├── theme/          # 主题配置
│   │   └── main.dart
│   └── pubspec.yaml
│
├── admin/                  # Vue3 管理后台
│   ├── src/
│   │   ├── views/          # 页面（Dashboard, Users, Orders, Gifts, Wallet）
│   │   ├── router/         # 路由配置
│   │   ├── api/            # API调用
│   │   └── store/          # 状态管理
│   └── package.json
│
├── deployment/             # 部署配置
│   ├── docker-compose.yml  # Docker编排
│   └── deploy.sh           # 部署脚本
│
└── docs/                   # 文档
```

## 快速启动

### 环境要求

- Node.js >= 18
- Python >= 3.10
- Flutter SDK >= 3.0
- MongoDB >= 6.0
- Redis >= 7.0
- Docker & Docker Compose（可选）

### 后端服务启动

```bash
cd backend
npm install
cp config/.env.example config/.env
# 编辑.env配置数据库连接
npm run dev
```

### AI内核启动

```bash
cd ai-core
pip install -r requirements.txt
python src/main.py
```

### 前端应用启动

```bash
cd frontend
flutter pub get
flutter run
```

### 管理后台启动

```bash
cd admin
npm install
npm run dev
```

### Docker部署

```bash
cd deployment
chmod +x deploy.sh
./deploy.sh
```

## 核心功能模块

### 1. 聊天陪伴模块
- 实时AI对话交互
- 情感分析与智能应答
- 多轮对话上下文记忆
- 语音输入支持

### 2. 情感储值钱包模块
- 心意存钱功能
- AES-256加密账本
- 双向送礼系统
- AI自动回礼机制
- 现金折现/实物兑付双通道

### 3. 礼物商城模块
- 心意信物
- 专属礼盒
- 亲密装扮
- 特别礼物

### 4. 个人中心模块
- 用户资料管理
- 互动数据统计
- 设置偏好

### 5. 运营管理后台
- 数据统计仪表盘
- 用户管理
- 订单管理
- 礼物配置
- 账本审计

## 安全机制

- 全链路HTTPS传输
- JWT Token认证
- AES-256金额加密
- 交易哈希存证防篡改
- 敏感数据脱敏
- 充值限额保护

## 技术特点

1. **自研AI内核**：区别于通用AI套壳，底层定制情感理解
2. **私有记忆系统**：用户数据本地存储，不上传第三方
3. **加密账本体系**：金融级安全保障
4. **双向情感闭环**：送礼→回礼→兑付完整链路

## 软件著作权说明

- **软件全称**：EVE自研内核级情感治愈AI陪伴及双向心意储值兑付系统V1.0
- **版本号**：V1.0
- **运行环境**：安卓/IOS移动端、Windows桌面端

## 许可证

专有软件，仅限授权使用。

---

**EVE** - 用心陪伴，治愈心灵
