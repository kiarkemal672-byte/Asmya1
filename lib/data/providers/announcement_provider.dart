import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class AnnouncementProvider extends ChangeNotifier {
  final ApiService api;
  List<Announcement> items = [];
  bool isLoading = false;
  String? error;

  AnnouncementProvider(this.api);

  Future<void> load() async {
    isLoading = true; notifyListeners();
    try {
      final list = await api.getAnnouncements();
      items = list.map((j) => Announcement.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) { error = e.toString(); }
    isLoading = false; notifyListeners();
  }

  Future<bool> create(String title, String content) async {
    try {
      await api.createAnnouncement(title, content);
      await load();
      return true;
    } catch (e) {
      error = e.toString(); notifyListeners();
      return false;
    }
  }

  Future<void> delete(String id) async {
    await api.deleteAnnouncement(id);
    items.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
