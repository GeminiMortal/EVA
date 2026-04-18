const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const Gift = require('../models/Gift');

router.get('/', auth, async (req, res, next) => {
  try {
    const gifts = await Gift.find({ isActive: true })
      .sort({ sortOrder: 1, createdAt: -1 });
    
    res.json({
      success: true,
      data: gifts
    });
  } catch (error) {
    next(error);
  }
});

router.get('/:id', auth, async (req, res, next) => {
  try {
    const gift = await Gift.findById(req.params.id);
    
    if (!gift) {
      return res.status(404).json({
        success: false,
        message: '礼物不存在'
      });
    }
    
    res.json({
      success: true,
      data: gift
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
