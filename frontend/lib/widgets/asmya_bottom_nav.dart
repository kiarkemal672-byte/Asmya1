import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class AsmyaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AsmyaBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = const [
      BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), label: 'Announcements'),
      BottomNavigationBarItem(icon: Icon(Icons.checklist_rounded), label: 'Plans'),
      BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Members'),
      BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
    ];
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).cardTheme.color,
      selectedFontSize: 12,
      unselectedFontSize: 11,
    );
  }
}
