const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  orderId: {
    type: String,
    required: true,
    unique: true
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  type: {
    type: String,
    enum: ['gift', 'deposit', 'redeem_cash', 'redeem_goods'],
    required: true
  },
  giftId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Gift'
  },
  amount: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'paid', 'processing', 'shipped', 'completed', 'cancelled', 'refunded'],
    default: 'pending'
  },
  shippingAddress: {
    name: String,
    phone: String,
    address: String,
    city: String,
    province: String,
    postalCode: String
  },
  trackingNumber: {
    type: String,
    default: ''
  },
  logisticsCompany: {
    type: String,
    default: ''
  },
  paymentMethod: {
    type: String,
    default: ''
  },
  paymentTime: {
    type: Date
  },
  paidAt: {
    type: Date
  },
  shippedAt: {
    type: Date
  },
  completedAt: {
    type: Date
  },
  notes: {
    type: String,
    default: ''
  }
}, {
  timestamps: true
});

orderSchema.index({ userId: 1, createdAt: -1 });
orderSchema.index({ orderId: 1 });

module.exports = mongoose.model('Order', orderSchema);
