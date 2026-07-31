import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;
  ApiException(this.statusCode, this.message, [this.details]);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  String? _token;
  String get _baseUrl => AppConstants.apiBaseUrl;

  void setToken(String? t) => _token = t;
  String? get token => _token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> future,
  ) async {
    final res = await future.timeout(AppConstants.apiTimeout);
    final body = res.body.isEmpty ? {} : jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw ApiException(res.statusCode, body['error']?.toString() ?? 'Request failed', body);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final body = await _handleRequest(http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'username': username, 'password': password}),
    ));
    _token = body['token'];
    return body;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
    final body = await _handleRequest(http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode(payload),
    ));
    _token = body['token'];
    return body;
  }

  Future<Map<String, dynamic>> me() async =>
      _handleRequest(http.get(Uri.parse('$_baseUrl/auth/me'), headers: _headers));

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> payload) async =>
      _handleRequest(http.put(Uri.parse('$_baseUrl/user/profile'),
          headers: _headers, body: jsonEncode(payload)));

  Future<Map<String, dynamic>> changePassword(
      String currentPassword, String newPassword) async =>
      _handleRequest(http.put(Uri.parse('$_baseUrl/user/password'),
          headers: _headers,
          body: jsonEncode({
            'current_password': currentPassword,
            'new_password': newPassword,
          })));

  Future<List<dynamic>> getConversations() async {
    final b = await _handleRequest(
        http.get(Uri.parse('$_baseUrl/chat/conversations'), headers: _headers));
    return b['conversations'] as List<dynamic>;
  }

  Future<List<dynamic>> getMessages(String conversationId) async {
    final b = await _handleRequest(http.get(
        Uri.parse('$_baseUrl/chat/conversations/$conversationId/messages'),
        headers: _headers));
    return b['messages'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> sendMessage(String conversationId, String content) async =>
      _handleRequest(http.post(
          Uri.parse('$_baseUrl/chat/conversations/$conversationId/messages'),
          headers: _headers,
          body: jsonEncode({'content': content})));

  Future<List<dynamic>> getAnnouncements() async {
    final b = await _handleRequest(
        http.get(Uri.parse('$_baseUrl/announcements'), headers: _headers));
    return b['announcements'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createAnnouncement(String title, String content) async =>
      _handleRequest(http.post(Uri.parse('$_baseUrl/announcements'),
          headers: _headers, body: jsonEncode({'title': title, 'content': content})));

  Future<void> deleteAnnouncement(String id) async => _handleRequest(
      http.delete(Uri.parse('$_baseUrl/announcements/$id'), headers: _headers));

  Future<List<dynamic>> getPlans() async {
    final b = await _handleRequest(
        http.get(Uri.parse('$_baseUrl/plans'), headers: _headers));
    return b['plans'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createPlan(Map<String, dynamic> payload) async =>
      _handleRequest(http.post(Uri.parse('$_baseUrl/plans'),
          headers: _headers, body: jsonEncode(payload)));

  Future<Map<String, dynamic>> updatePlanStatus(String id, String status) async =>
      _handleRequest(http.put(Uri.parse('$_baseUrl/plans/$id/status'),
          headers: _headers, body: jsonEncode({'status': status})));

  Future<void> deletePlan(String id) async => _handleRequest(
      http.delete(Uri.parse('$_baseUrl/plans/$id'), headers: _headers));

  Future<List<dynamic>> getReports() async {
    final b = await _handleRequest(
        http.get(Uri.parse('$_baseUrl/reports'), headers: _headers));
    return b['reports'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> payload) async =>
      _handleRequest(http.post(Uri.parse('$_baseUrl/reports'),
          headers: _headers, body: jsonEncode(payload)));

  Future<void> deleteReport(String id) async => _handleRequest(
      http.delete(Uri.parse('$_baseUrl/reports/$id'), headers: _headers));

  Future<Map<String, dynamic>> getCashbook() async {
    return _handleRequest(
        http.get(Uri.parse('$_baseUrl/cashbook'), headers: _headers));
  }

  Future<Map<String, dynamic>> createCashbook(Map<String, dynamic> payload) async =>
      _handleRequest(http.post(Uri.parse('$_baseUrl/cashbook'),
          headers: _headers, body: jsonEncode(payload)));

  Future<void> deleteCashbook(String id) async => _handleRequest(
      http.delete(Uri.parse('$_baseUrl/cashbook/$id'), headers: _headers));

  Future<List<dynamic>> getMembers({String filter = 'all'}) async {
    final b = await _handleRequest(http.get(
        Uri.parse('$_baseUrl/members?filter=$filter'),
        headers: _headers));
    return b['members'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> addMember(Map<String, dynamic> payload) async =>
      _handleRequest(http.post(Uri.parse('$_baseUrl/members'),
          headers: _headers, body: jsonEncode(payload)));
}
