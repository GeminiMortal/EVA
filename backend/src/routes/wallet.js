const express = require('express');
const router = express.Router();
const walletService = require('../services/walletService');
const auth = require('../middleware/auth');

router.get('/info', auth, async (req, res, next) => {
  try {
    const walletInfo = await walletService.getWalletInfo(req.user.id);
    res.json({
      success: true,
      data: walletInfo
    });
  } catch (error) {
    next(error);
  }
});

router.post('/deposit', auth, async (req, res, next) => {
  try {
    const { amount, description } = req.body;
    if (!amount || amount <= 0) {
      return res.status(400).json({
        success: false,
        message: '请输入有效的金额'
      });
    }
    
    const result = await walletService.deposit(req.user.id, amount, description);
    res.json(result);
  } catch (error) {
    next(error);
  }
});

router.post('/deposit/confirm', auth, async (req, res, next) => {
  try {
    const { orderId } = req.body;
    const result = await walletService.confirmDeposit(orderId);
    res.json(result);
  } catch (error) {
    next(error);
  }
});

router.post('/gift', auth, async (req, res, next) => {
  try {
    const { giftId, giftPrice, affectionBonus } = req.body;
    const result = await walletService.sendGift(
      req.user.id, 
      giftId, 
      giftPrice, 
      affectionBonus
    );
    res.json(result);
  } catch (error) {
    next(error);
  }
});

router.post('/redeem', auth, async (req, res, next) => {
  try {
    const { type, shippingInfo } = req.body;
    if (!['cash', 'goods'].includes(type)) {
      return res.status(400).json({
        success: false,
        message: '无效的兑付类型'
      });
    }
    
    const result = await walletService.redeemReward(
      req.user.id, 
      type, 
      shippingInfo
    );
    res.json(result);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
