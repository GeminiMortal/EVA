const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const Chat = require('../models/Chat');
const axios = require('axios');

router.post('/send', auth, async (req, res, next) => {
  try {
    const { content, sessionId } = req.body;
    
    const aiResponse = await axios.post(
      `${process.env.AI_CORE_URL}/api/chat`,
      {
        user_id: req.user.id.toString(),
        content,
        session_id: sessionId
      }
    );
    
    let chat = await Chat.findOne({
      userId: req.user.id,
      sessionId: sessionId || 'default'
    });
    
    if (!chat) {
      chat = new Chat({
        userId: req.user.id,
        sessionId: sessionId || 'default',
        messages: []
      });
    }
    
    chat.messages.push({
      role: 'user',
      content,
      timestamp: new Date()
    });
    
    chat.messages.push({
      role: 'assistant',
      content: aiResponse.data.content,
      emotion: aiResponse.data.emotion,
      timestamp: new Date()
    });
    
    if (!chat.emotionTags.includes(aiResponse.data.emotion)) {
      chat.emotionTags.push(aiResponse.data.emotion);
    }
    
    await chat.save();
    
    res.json({
      success: true,
      data: {
        ...aiResponse.data,
        sessionId: chat.sessionId
      }
    });
  } catch (error) {
    next(error);
  }
});

router.get('/history', auth, async (req, res, next) => {
  try {
    const chats = await Chat.find({ userId: req.user.id })
      .sort({ createdAt: -1 })
      .limit(20);
    
    res.json({
      success: true,
      data: chats
    });
  } catch (error) {
    next(error);
  }
});

router.get('/session/:sessionId', auth, async (req, res, next) => {
  try {
    const chat = await Chat.findOne({
      userId: req.user.id,
      sessionId: req.params.sessionId
    });
    
    res.json({
      success: true,
      data: chat
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
