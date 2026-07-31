import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/router/app_router.dart';

class _RoleDef {
  final String key;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  const _RoleDef(this.key, this.title, this.desc, this.icon, this.color);
}

class RoleSelectionScreen extends StatelessWidget {
  RoleSelectionScreen({super.key});

  final roles = const [
    _RoleDef('TEACHER', 'Teacher',
        'Manage attendance, assessments, and communicate with students & parents',
        Icons.menu_book_rounded, AppColors.blue),
    _RoleDef('STUDENT', 'Student',
        'View daily activities, test results, and announcements',
        Icons.school_rounded, AppColors.green),
    _RoleDef('PARENT', 'Parent',
        'Monitor your child progress, attendance, and communicate with teachers',
        Icons.people_alt_rounded, AppColors.purple),
    _RoleDef('ADMIN_AMIR', 'Admin (Amir)',
        'Men/Women administration side',
        Icons.lock_rounded, AppColors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.gold),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              const Text('Choose Your Role',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.gold)),
              const SizedBox(height: 8),
              Text('Select how you want to participate in ASMYA',
                  style: TextStyle(
                      color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 13)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: roles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final r = roles[i];
                    return _roleCard(context, r, dark);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context, _RoleDef r, bool dark) {
    return GestureDetector(
      onTap: () {
        if (r.key == 'ADMIN_AMIR') {
          Navigator.of(context).pushNamed(AppRouter.gender, arguments: r.key);
        } else {
          Navigator.of(context).pushNamed(AppRouter.signIn, arguments: {'role': r.key});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: r.color.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(r.icon, color: r.color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.title,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  const SizedBox(height: 4),
                  Text(r.desc,
                      style: TextStyle(
                          fontSize: 12,
                          color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gold),
          ],
        ),
      ),
    );
  }
}
