const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  messages: [{
    role: {
      type: String,
      enum: ['user', 'assistant'],
      required: true
    },
    content: {
      type: String,
      required: true
    },
    timestamp: {
      type: Date,
      default: Date.now
    },
    emotion: {
      type: String,
      default: 'neutral'
    },
    media: {
      type: String,
      default: ''
    }
  }],
  sessionId: {
    type: String,
    required: true
  },
  summary: {
    type: String,
    default: ''
  },
  emotionTags: [{
    type: String
  }]
}, {
  timestamps: true
});

chatSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model('Chat', chatSchema);
