const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const Order = require('../models/Order');

router.get('/', auth, async (req, res, next) => {
  try {
    const { status, limit = 20 } = req.query;
    const query = { userId: req.user.id };
    
    if (status) {
      query.status = status;
    }
    
    const orders = await Order.find(query)
      .populate('giftId')
      .sort({ createdAt: -1 })
      .limit(parseInt(limit));
    
    res.json({
      success: true,
      data: orders
    });
  } catch (error) {
    next(error);
  }
});

router.get('/:orderId', auth, async (req, res, next) => {
  try {
    const order = await Order.findOne({
      orderId: req.params.orderId,
      userId: req.user.id
    }).populate('giftId');
    
    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在'
      });
    }
    
    res.json({
      success: true,
      data: order
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
