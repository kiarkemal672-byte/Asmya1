import 'package:flutter/material.dart';
import 'chat/chat_screen.dart';
import 'announcements/announcements_screen.dart';
import 'plans/plans_screen.dart';
import 'members/members_screen.dart';
import 'settings/settings_screen.dart';
import '../widgets/asmya_bottom_nav.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;
  final _screens = const [
    ChatScreen(),
    AnnouncementsScreen(),
    PlansScreen(),
    MembersScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: AsmyaBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
