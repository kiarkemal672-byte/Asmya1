import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/router/app_router.dart';

class GenderSelectionScreen extends StatelessWidget {
  final String? role;
  const GenderSelectionScreen({super.key, this.role});

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
              const Text('Choose Your Side',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.gold)),
              const SizedBox(height: 8),
              Text('Select the section you belong to',
                  style: TextStyle(
                      color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 13)),
              const SizedBox(height: 28),
              _sideCard(context, 'Men', "Enter the brothers' section", Icons.man_rounded,
                  AppColors.blue, 'MEN', dark),
              const SizedBox(height: 16),
              _sideCard(context, 'Women', "Enter the sisters' section", Icons.woman_rounded,
                  AppColors.pink, 'WOMEN', dark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sideCard(BuildContext context, String title, String desc, IconData icon,
      Color color, String side, bool dark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRouter.signIn,
          arguments: {'role': role ?? 'ADMIN_AMIR', 'side': side}),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: dark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: TextStyle(
                          fontSize: 13,
                          color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
