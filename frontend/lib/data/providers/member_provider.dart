import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class MemberProvider extends ChangeNotifier {
  final ApiService api;
  List<User> members = [];
  bool isLoading = false;
  String? error;
  String filter = 'all';

  MemberProvider(this.api);

  Future<void> load() async {
    isLoading = true; notifyListeners();
    try {
      final list = await api.getMembers(filter: filter);
      members = list.map((j) => User.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) { error = e.toString(); }
    isLoading = false; notifyListeners();
  }

  void setFilter(String f) { filter = f; load(); }

  Future<bool> add(Map<String, dynamic> payload) async {
    try {
      await api.addMember(payload);
      await load();
      return true;
    } catch (e) { error = e.toString(); notifyListeners(); return false; }
  }
}
