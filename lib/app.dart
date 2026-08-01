import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/providers/theme_provider.dart';
import 'data/providers/language_provider.dart';

class AsmyaApp extends StatelessWidget {
  const AsmyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final langProv = context.watch<LanguageProvider>();
    return MaterialApp(
      title: 'ASMYA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProv.isDark ? ThemeMode.dark : ThemeMode.light,
      locale: langProv.locale,
      supportedLocales: const [
        Locale('en'), Locale('am'), Locale('ar'),
      ],
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
