const mongoose = require('mongoose');

const giftSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true
  },
  imageUrl: {
    type: String,
    required: true
  },
  category: {
    type: String,
    enum: ['token', 'box', 'costume', 'special'],
    required: true
  },
  affectionBonus: {
    type: Number,
    default: 0
  },
  effect: {
    type: String,
    default: ''
  },
  stock: {
    type: Number,
    default: -1
  },
  isActive: {
    type: Boolean,
    default: true
  },
  sortOrder: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Gift', giftSchema);
