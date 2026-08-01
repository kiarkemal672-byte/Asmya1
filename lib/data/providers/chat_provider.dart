import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService api;
  List<Conversation> conversations = [];
  bool isLoading = false;
  String? error;

  ChatProvider(this.api);

  Future<void> load() async {
    isLoading = true; error = null; notifyListeners();
    try {
      final list = await api.getConversations();
      conversations = list.map((j) => Conversation.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      error = e.toString();
    }
    isLoading = false; notifyListeners();
  }
}
