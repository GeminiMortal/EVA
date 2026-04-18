const Wallet = require('../models/Wallet');
const User = require('../models/User');
const Order = require('../models/Order');
const logger = require('../utils/logger');

const generateTransactionId = () => {
  return `TXN${Date.now()}${Math.random().toString(36).substr(2, 9).toUpperCase()}`;
};

const generateOrderId = () => {
  return `ORD${Date.now()}${Math.random().toString(36).substr(2, 6).toUpperCase()}`;
};

const walletService = {
  async getOrCreateWallet(userId) {
    let wallet = await Wallet.findOne({ userId });
    if (!wallet) {
      wallet = new Wallet({
        userId,
        encryptedBalance: '',
        totalDeposited: '',
        totalGifted: '',
        totalRedeemed: '',
        pendingReward: ''
      });
      wallet.encryptedBalance = wallet.encryptAmount(0);
      wallet.totalDeposited = wallet.encryptAmount(0);
      wallet.totalGifted = wallet.encryptAmount(0);
      wallet.totalRedeemed = wallet.encryptAmount(0);
      wallet.pendingReward = wallet.encryptAmount(0);
      await wallet.save();
    }
    return wallet;
  },

  async deposit(userId, amount, description = '心意存钱') {
    const wallet = await this.getOrCreateWallet(userId);
    const user = await User.findById(userId);
    
    const transactionId = generateTransactionId();
    const orderId = generateOrderId();
    
    const transaction = {
      transactionId,
      type: 'deposit',
      encryptedAmount: wallet.encryptAmount(amount),
      description,
      status: 'pending'
    };
    
    const order = new Order({
      orderId,
      userId,
      type: 'deposit',
      amount,
      status: 'pending'
    });
    await order.save();
    
    return {
      success: true,
      orderId,
      transactionId,
      message: '存款订单已创建，请完成支付'
    };
  },

  async confirmDeposit(orderId) {
    const order = await Order.findOne({ orderId });
    if (!order || order.status !== 'pending') {
      throw new Error('订单无效或已处理');
    }
    
    const wallet = await this.getOrCreateWallet(order.userId);
    const transactionId = generateTransactionId();
    
    wallet.updateBalance(order.amount, {
      transactionId,
      type: 'deposit',
      encryptedAmount: wallet.encryptAmount(order.amount),
      description: '心意存钱到账',
      status: 'completed'
    });
    
    const totalDeposited = wallet.decryptAmount(wallet.totalDeposited) + order.amount;
    wallet.totalDeposited = wallet.encryptAmount(totalDeposited);
    
    const user = await User.findById(order.userId);
    user.affectionLevel += Math.floor(order.amount / 10);
    await user.save();
    
    order.status = 'paid';
    order.paidAt = new Date();
    await order.save();
    
    await wallet.save();
    
    logger.info(`用户 ${order.userId} 存款 ${order.amount} 元成功`);
    
    return { success: true, message: '存款成功' };
  },

  async sendGift(userId, giftId, giftPrice, affectionBonus) {
    const wallet = await this.getOrCreateWallet(userId);
    const user = await User.findById(userId);
    
    const currentBalance = wallet.getBalance();
    if (currentBalance < giftPrice) {
      throw new Error('心意余额不足');
    }
    
    const transactionId = generateTransactionId();
    
    wallet.updateBalance(giftPrice, {
      transactionId,
      type: 'gift',
      encryptedAmount: wallet.encryptAmount(giftPrice),
      description: '赠送心意礼物',
      status: 'completed'
    });
    
    const totalGifted = wallet.decryptAmount(wallet.totalGifted) + giftPrice;
    wallet.totalGifted = wallet.encryptAmount(totalGifted);
    
    user.affectionLevel += affectionBonus;
    await user.save();
    
    await wallet.save();
    
    logger.info(`用户 ${userId} 赠送礼物成功，金额 ${giftPrice} 元`);
    
    return this.checkAndTriggerReward(userId, wallet, user);
  },

  async checkAndTriggerReward(userId, wallet, user) {
    const now = new Date();
    const lastTrigger = wallet.lastRewardTriggeredAt;
    
    const shouldTrigger = (!lastTrigger || 
      (now - lastTrigger > 7 * 24 * 60 * 60 * 1000)) && 
      user.affectionLevel >= 100;
    
    if (shouldTrigger) {
      const rewardAmount = Math.floor(Math.random() * 50) + 10;
      const pendingReward = wallet.decryptAmount(wallet.pendingReward) + rewardAmount;
      wallet.pendingReward = wallet.encryptAmount(pendingReward);
      wallet.lastRewardTriggeredAt = now;
      await wallet.save();
      
      logger.info(`用户 ${userId} 触发AI回礼 ${rewardAmount} 元`);
      
      return {
        success: true,
        giftSent: true,
        rewardTriggered: true,
        rewardAmount,
        message: `礼物赠送成功！EVE为您准备了 ${rewardAmount} 元心意回馈`
      };
    }
    
    return {
      success: true,
      giftSent: true,
      rewardTriggered: false,
      message: '礼物赠送成功'
    };
  },

  async redeemReward(userId, redeemType, shippingInfo = null) {
    const wallet = await this.getOrCreateWallet(userId);
    const pendingReward = wallet.decryptAmount(wallet.pendingReward);
    
    if (pendingReward <= 0) {
      throw new Error('没有待兑付的心意回馈');
    }
    
    const transactionId = generateTransactionId();
    const orderId = generateOrderId();
    
    wallet.updateBalance(-pendingReward, {
      transactionId,
      type: redeemType === 'cash' ? 'redeem_cash' : 'redeem_goods',
      encryptedAmount: wallet.encryptAmount(pendingReward),
      description: redeemType === 'cash' ? '心意折现兑付' : '心意实物兑付',
      status: 'pending'
    });
    
    const totalRedeemed = wallet.decryptAmount(wallet.totalRedeemed) + pendingReward;
    wallet.totalRedeemed = wallet.encryptAmount(totalRedeemed);
    wallet.pendingReward = wallet.encryptAmount(0);
    
    const order = new Order({
      orderId,
      userId,
      type: redeemType === 'cash' ? 'redeem_cash' : 'redeem_goods',
      amount: pendingReward,
      status: 'processing',
      shippingAddress: shippingInfo
    });
    await order.save();
    
    await wallet.save();
    
    logger.info(`用户 ${userId} 发起兑付 ${pendingReward} 元，类型: ${redeemType}`);
    
    return {
      success: true,
      orderId,
      amount: pendingReward,
      message: '兑付申请已提交，将尽快处理'
    };
  },

  async getWalletInfo(userId) {
    const wallet = await this.getOrCreateWallet(userId);
    return {
      balance: wallet.getBalance(),
      totalDeposited: wallet.decryptAmount(wallet.totalDeposited),
      totalGifted: wallet.decryptAmount(wallet.totalGifted),
      totalRedeemed: wallet.decryptAmount(wallet.totalRedeemed),
      pendingReward: wallet.decryptAmount(wallet.pendingReward),
      recentTransactions: wallet.transactions.slice(0, 10).map(tx => ({
        transactionId: tx.transactionId,
        type: tx.type,
        amount: wallet.decryptAmount(tx.encryptedAmount),
        description: tx.description,
        timestamp: tx.timestamp,
        status: tx.status
      }))
    };
  }
};

module.exports = walletService;
