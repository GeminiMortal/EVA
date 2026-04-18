const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const Memory = require('../models/Memory');
const axios = require('axios');

router.get('/', auth, async (req, res, next) => {
  try {
    const { type, limit = 20 } = req.query;
    const query = { userId: req.user.id };
    
    if (type) {
      query.memoryType = type;
    }
    
    const memories = await Memory.find(query)
      .sort({ importance: -1, createdAt: -1 })
      .limit(parseInt(limit));
    
    res.json({
      success: true,
      data: memories
    });
  } catch (error) {
    next(error);
  }
});

router.get('/:id', auth, async (req, res, next) => {
  try {
    const memory = await Memory.findOne({
      _id: req.params.id,
      userId: req.user.id
    });
    
    if (!memory) {
      return res.status(404).json({
        success: false,
        message: '记忆不存在'
      });
    }
    
    memory.recalledCount += 1;
    memory.lastRecalledAt = new Date();
    await memory.save();
    
    res.json({
      success: true,
      data: memory
    });
  } catch (error) {
    next(error);
  }
});

router.post('/save', auth, async (req, res, next) => {
  try {
    const { content, memoryType, emotion, importance } = req.body;
    
    const aiResult = await axios.post(
      `${process.env.AI_CORE_URL}/api/memory/save`,
      {
        user_id: req.user.id.toString(),
        content,
        memory_type: memoryType,
        emotion,
        importance
      }
    );
    
    const memory = new Memory({
      userId: req.user.id,
      content,
      memoryType: memoryType || 'event',
      emotion: emotion || 'neutral',
      importance: importance || 5,
      tags: []
    });
    
    await memory.save();
    
    res.json({
      success: true,
      data: memory
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
