import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;
  String? _token;
  
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  
  Future<void> loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userStr = prefs.getString('user');
    
    if (_token != null && userStr != null) {
      _user = userStr;
      _isAuthenticated = true;
      notifyListeners();
    }
  }
  
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? nickname,
  }) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'username': username,
        'email': email,
        'password': password,
        'nickname': nickname ?? username,
      });
      
      if (response['success']) {
        _token = response['data']['token'];
        _user = response['data']['user'];
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', response['data']['user'].toString());
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('注册错误: $e');
      return false;
    }
  }
  
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      
      if (response['success']) {
        _token = response['data']['token'];
        _user = response['data']['user'];
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', response['data']['user'].toString());
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('登录错误: $e');
      return false;
    }
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    
    _token = null;
    _user = null;
    _isAuthenticated = false;
    
    notifyListeners();
  }
  
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/user/profile', data);
      if (response['success']) {
        _user = response['data'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('更新资料错误: $e');
    }
  }
}
