const mongoose = require('mongoose');
const CryptoJS = require('crypto-js');

const walletSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  encryptedBalance: {
    type: String,
    required: true,
    default: ''
  },
  totalDeposited: {
    type: String,
    required: true,
    default: ''
  },
  totalGifted: {
    type: String,
    required: true,
    default: ''
  },
  totalRedeemed: {
    type: String,
    required: true,
    default: ''
  },
  pendingReward: {
    type: String,
    required: true,
    default: ''
  },
  transactions: [{
    transactionId: {
      type: String,
      required: true,
      unique: true
    },
    type: {
      type: String,
      enum: ['deposit', 'gift', 'reward', 'redeem_cash', 'redeem_goods'],
      required: true
    },
    encryptedAmount: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    timestamp: {
      type: Date,
      default: Date.now
    },
    hash: {
      type: String,
      required: true
    },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed'],
      default: 'completed'
    }
  }],
  lastRewardTriggeredAt: {
    type: Date
  }
}, {
  timestamps: true
});

walletSchema.methods.encryptAmount = function(amount) {
  const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
  const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);
  return CryptoJS.AES.encrypt(amount.toString(), key, { iv: iv }).toString();
};

walletSchema.methods.decryptAmount = function(encrypted) {
  const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
  const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);
  const bytes = CryptoJS.AES.decrypt(encrypted, key, { iv: iv });
  return parseFloat(bytes.toString(CryptoJS.enc.Utf8));
};

walletSchema.methods.generateHash = function(data) {
  return CryptoJS.SHA256(JSON.stringify(data) + process.env.ENCRYPTION_KEY).toString();
};

walletSchema.methods.getBalance = function() {
  return this.decryptAmount(this.encryptedBalance);
};

walletSchema.methods.updateBalance = function(amountChange, transaction) {
  const currentBalance = this.getBalance();
  const newBalance = currentBalance + amountChange;
  this.encryptedBalance = this.encryptAmount(newBalance);
  
  transaction.hash = this.generateHash(transaction);
  this.transactions.unshift(transaction);
  
  return newBalance;
};

module.exports = mongoose.model('Wallet', walletSchema);
