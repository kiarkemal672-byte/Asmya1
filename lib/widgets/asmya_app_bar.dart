import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/theme_provider.dart';
import '../data/providers/language_provider.dart';

class AsmyaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showActions;
  const AsmyaAppBar({super.key, this.title, this.showActions = true});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final langProv = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(title ?? 'ASMYA',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                )),
            const Spacer(),
            if (showActions) ...[
              if (auth.user != null)
                GestureDetector(
                  onTap: () => _showLanguageMenu(context, langProv),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.gold,
                    child: Text(
                      auth.user!.initials,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(themeProv.isDark ? Icons.light_mode : Icons.dark_mode,
                    color: AppColors.gold, size: 22),
                onPressed: themeProv.toggle,
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.red, size: 22),
                onPressed: () async {
                  await auth.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLanguageMenu(BuildContext context, LanguageProvider prov) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: const [
        PopupMenuItem(value: 'en', child: Text('English')),
        PopupMenuItem(value: 'am', child: Text('አማርኛ')),
        PopupMenuItem(value: 'ar', child: Text('العربية')),
      ],
    ).then((v) {
      if (v != null) prov.setLanguage(v);
    });
  }
}
