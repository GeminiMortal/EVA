const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const walletService = require('../services/walletService');

router.post('/register', async (req, res, next) => {
  try {
    const { username, email, password, nickname } = req.body;
    
    const existingUser = await User.findOne({
      $or: [{ email }, { username }]
    });
    
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: '用户名或邮箱已存在'
      });
    }
    
    const user = new User({
      username,
      email,
      password,
      nickname: nickname || username
    });
    
    await user.save();
    await walletService.getOrCreateWallet(user._id);
    
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );
    
    res.status(201).json({
      success: true,
      message: '注册成功',
      data: {
        token,
        user: {
          id: user._id,
          username: user.username,
          email: user.email,
          nickname: user.nickname,
          affectionLevel: user.affectionLevel
        }
      }
    });
  } catch (error) {
    next(error);
  }
});

router.post('/login', async (req, res, next) => {
  try {
    const { email, password } = req.body;
    
    const user = await User.findOne({ email });
    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({
        success: false,
        message: '邮箱或密码错误'
      });
    }
    
    user.lastActive = new Date();
    await user.save();
    
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );
    
    res.json({
      success: true,
      message: '登录成功',
      data: {
        token,
        user: {
          id: user._id,
          username: user.username,
          email: user.email,
          nickname: user.nickname,
          avatar: user.avatar,
          affectionLevel: user.affectionLevel
        }
      }
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
