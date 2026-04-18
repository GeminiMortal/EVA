import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class Transaction {
  final String id;
  final String type;
  final double amount;
  final String description;
  final DateTime timestamp;
  final String status;
  
  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
  });
}

class WalletProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  double _balance = 0;
  double _totalDeposited = 0;
  double _totalGifted = 0;
  double _totalRedeemed = 0;
  double _pendingReward = 0;
  List<Transaction> _transactions = [];
  
  double get balance => _balance;
  double get pendingReward => _pendingReward;
  double get totalDeposited => _totalDeposited;
  double get totalGifted => _totalGifted;
  List<Transaction> get transactions => _transactions;
  
  Future<void> loadWalletInfo() async {
    try {
      final response = await _apiService.get('/wallet/info');
      if (response['success']) {
        final data = response['data'];
        _balance = data['balance']?.toDouble() ?? 0;
        _totalDeposited = data['totalDeposited']?.toDouble() ?? 0;
        _totalGifted = data['totalGifted']?.toDouble() ?? 0;
        _totalRedeemed = data['totalRedeemed']?.toDouble() ?? 0;
        _pendingReward = data['pendingReward']?.toDouble() ?? 0;
        
        _transactions = (data['recentTransactions'] as List? ?? [])
            .map((t) => Transaction(
                  id: t['transactionId'],
                  type: t['type'],
                  amount: t['amount'].toDouble(),
                  description: t['description'],
                  timestamp: DateTime.parse(t['timestamp']),
                  status: t['status'],
                ))
            .toList();
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('加载钱包信息错误: $e');
    }
  }
  
  Future<Map<String, dynamic>?> deposit(double amount, {String? description}) async {
    try {
      final response = await _apiService.post('/wallet/deposit', {
        'amount': amount,
        'description': description ?? '心意存钱',
      });
      
      if (response['success']) {
        return response;
      }
      return null;
    } catch (e) {
      debugPrint('存款错误: $e');
      return null;
    }
  }
  
  Future<bool> confirmDeposit(String orderId) async {
    try {
      final response = await _apiService.post('/wallet/deposit/confirm', {
        'orderId': orderId,
      });
      
      if (response['success']) {
        await loadWalletInfo();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('确认存款错误: $e');
      return false;
    }
  }
  
  Future<Map<String, dynamic>?> sendGift({
    required String giftId,
    required double giftPrice,
    required int affectionBonus,
  }) async {
    try {
      final response = await _apiService.post('/wallet/gift', {
        'giftId': giftId,
        'giftPrice': giftPrice,
        'affectionBonus': affectionBonus,
      });
      
      if (response['success']) {
        await loadWalletInfo();
        return response;
      }
      return null;
    } catch (e) {
      debugPrint('送礼错误: $e');
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> redeemReward(String type, {Map? shippingInfo}) async {
    try {
      final response = await _apiService.post('/wallet/redeem', {
        'type': type,
        'shippingInfo': shippingInfo,
      });
      
      if (response['success']) {
        await loadWalletInfo();
        return response;
      }
      return null;
    } catch (e) {
      debugPrint('兑付错误: $e');
      return null;
    }
  }
}
