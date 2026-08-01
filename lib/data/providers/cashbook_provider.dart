import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class CashbookProvider extends ChangeNotifier {
  final ApiService api;
  CashbookSummary? summary;
  List<CashbookTransaction> transactions = [];
  bool isLoading = false;
  String? error;

  CashbookProvider(this.api);

  Future<void> load() async {
    isLoading = true; notifyListeners();
    try {
      final data = await api.getCashbook();
      summary = CashbookSummary.fromJson(data['summary'] as Map<String, dynamic>);
      transactions = (data['transactions'] as List<dynamic>)
          .map((j) => CashbookTransaction.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) { error = e.toString(); }
    isLoading = false; notifyListeners();
  }

  Future<bool> create(Map<String, dynamic> payload) async {
    try {
      await api.createCashbook(payload);
      await load();
      return true;
    } catch (e) { error = e.toString(); notifyListeners(); return false; }
  }

  Future<void> delete(String id) async {
    await api.deleteCashbook(id);
    await load();
  }
}
