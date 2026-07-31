import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class PlanProvider extends ChangeNotifier {
  final ApiService api;
  List<Plan> plans = [];
  List<Report> reports = [];
  bool isLoading = false;
  String? error;

  PlanProvider(this.api);

  Future<void> loadPlans() async {
    isLoading = true; notifyListeners();
    try {
      final list = await api.getPlans();
      plans = list.map((j) => Plan.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) { error = e.toString(); }
    isLoading = false; notifyListeners();
  }

  Future<void> loadReports() async {
    try {
      final list = await api.getReports();
      reports = list.map((j) => Report.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) { error = e.toString(); }
    notifyListeners();
  }

  Future<bool> createPlan(Map<String, dynamic> payload) async {
    try {
      await api.createPlan(payload);
      await loadPlans();
      return true;
    } catch (e) { error = e.toString(); notifyListeners(); return false; }
  }

  Future<void> updateStatus(String id, String status) async {
    await api.updatePlanStatus(id, status);
    await loadPlans();
  }

  Future<void> deletePlan(String id) async {
    await api.deletePlan(id);
    plans.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Future<bool> createReport(Map<String, dynamic> payload) async {
    try {
      await api.createReport(payload);
      await loadReports();
      return true;
    } catch (e) { error = e.toString(); notifyListeners(); return false; }
  }

  Future<void> deleteReport(String id) async {
    await api.deleteReport(id);
    reports.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
