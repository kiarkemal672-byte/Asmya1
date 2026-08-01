import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/providers/language_provider.dart';
import 'data/providers/chat_provider.dart';
import 'data/providers/announcement_provider.dart';
import 'data/providers/plan_provider.dart';
import 'data/providers/cashbook_provider.dart';
import 'data/providers/member_provider.dart';
import 'data/services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ChatProvider(apiService)),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider(apiService)),
        ChangeNotifierProvider(create: (_) => PlanProvider(apiService)),
        ChangeNotifierProvider(create: (_) => CashbookProvider(apiService)),
        ChangeNotifierProvider(create: (_) => MemberProvider(apiService)),
      ],
      child: const AsmyaApp(),
    ),
  );
}
