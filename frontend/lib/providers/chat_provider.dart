import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class ChatMessage {
  final String role;
  final String content;
  final String? emotion;
  final List<String>? emojis;
  final DateTime timestamp;
  
  ChatMessage({
    required this.role,
    required this.content,
    this.emotion,
    this.emojis,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthProvider? _authProvider;
  
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String _sessionId = 'default';
  
  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  String get sessionId => _sessionId;
  
  ChatProvider([this._authProvider]);
  
  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }
  
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    
    final userMessage = ChatMessage(
      role: 'user',
      content: content,
    );
    addMessage(userMessage);
    
    _isTyping = true;
    notifyListeners();
    
    try {
      final response = await _apiService.post('/chat/send', {
        'content': content,
        'sessionId': _sessionId,
      });
      
      if (response['success']) {
        final aiResponse = response['data'];
        
        final aiMessage = ChatMessage(
          role: 'assistant',
          content: aiResponse['content'],
          emotion: aiResponse['emotion'],
          emojis: List<String>.from(aiResponse['suggested_emojis'] ?? []),
        );
        
        _sessionId = aiResponse['sessionId'] ?? _sessionId;
        addMessage(aiMessage);
      }
    } catch (e) {
      debugPrint('发送消息错误: $e');
      
      final errorMessage = ChatMessage(
        role: 'assistant',
        content: '抱歉，我刚才有点走神了...能再说一遍吗？',
      );
      addMessage(errorMessage);
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }
  
  Future<void> loadHistory() async {
    try {
      final response = await _apiService.get('/chat/history');
      if (response['success']) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('加载历史记录错误: $e');
    }
  }
  
  void clearChat() {
    _messages = [];
    notifyListeners();
  }
}
