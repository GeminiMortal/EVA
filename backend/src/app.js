const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config({ path: '../config/.env' });

const logger = require('./utils/logger');
const errorHandler = require('./middleware/errorHandler');

const app = express();

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 1000
});

app.use(limiter);
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

app.use('/api/auth', require('./routes/auth'));
app.use('/api/chat', require('./routes/chat'));
app.use('/api/memory', require('./routes/memory'));
app.use('/api/wallet', require('./routes/wallet'));
app.use('/api/gift', require('./routes/gift'));
app.use('/api/order', require('./routes/order'));
app.use('/api/user', require('./routes/user'));

app.use(errorHandler);

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    logger.info('MongoDB连接成功');
  } catch (error) {
    logger.error('MongoDB连接失败:', error);
    process.exit(1);
  }
};

connectDB();

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`EVE后端服务运行在端口 ${PORT}`);
});
