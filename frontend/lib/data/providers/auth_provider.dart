import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  final _storage = const FlutterSecureStorage();
  User? user;
  bool isLoading = false;
  String? error;
  String? pendingRole;
  String? pendingSide;

  AuthProvider(this.api) { _init(); }

  Future<void> _init() async {
    final token = await _storage.read(key: 'asmya_token');
    if (token != null) {
      api.setToken(token);
      try {
        final me = await api.me();
        user = User.fromJson(me['user'] as Map<String, dynamic>);
      } catch (_) {
        await _storage.delete(key: 'asmya_token');
      }
    }
    notifyListeners();
  }

  void setRole(String? role) { pendingRole = role; notifyListeners(); }
  void setSide(String? side) { pendingSide = side; notifyListeners(); }

  Future<bool> login(String username, String password) async {
    isLoading = true; error = null; notifyListeners();
    try {
      final res = await api.login(username, password);
      await _storage.write(key: 'asmya_token', value: api.token);
      user = User.fromJson(res['user'] as Map<String, dynamic>);
      isLoading = false; notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false; notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> payload) async {
    isLoading = true; error = null; notifyListeners();
    try {
      final res = await api.register(payload);
      await _storage.write(key: 'asmya_token', value: api.token);
      user = User.fromJson(res['user'] as Map<String, dynamic>);
      isLoading = false; notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false; notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'asmya_token');
    api.setToken(null);
    user = null;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    try {
      final me = await api.me();
      user = User.fromJson(me['user'] as Map<String, dynamic>);
      notifyListeners();
    } catch (_) {}
  }
}
