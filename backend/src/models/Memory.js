const mongoose = require('mongoose');

const memorySchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  memoryType: {
    type: String,
    enum: ['event', 'emotion', 'regret', 'preference'],
    required: true
  },
  content: {
    type: String,
    required: true
  },
  vectorEmbedding: {
    type: [Number],
    default: []
  },
  emotion: {
    type: String,
    default: 'neutral'
  },
  emotionIntensity: {
    type: Number,
    min: 0,
    max: 10,
    default: 5
  },
  importance: {
    type: Number,
    min: 0,
    max: 10,
    default: 5
  },
  tags: [{
    type: String
  }],
  relatedMemories: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Memory'
  }],
  isRecalled: {
    type: Boolean,
    default: false
  },
  recalledCount: {
    type: Number,
    default: 0
  },
  lastRecalledAt: {
    type: Date
  }
}, {
  timestamps: true
});

memorySchema.index({ userId: 1, memoryType: 1, importance: -1 });
memorySchema.index({ userId: 1, 'vectorEmbedding': '2dsphere' });

module.exports = mongoose.model('Memory', memorySchema);
