import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../core/router/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: dark
                ? [AppColors.darkBgGradientTop, AppColors.darkBg]
                : [AppColors.lightBgGradientTop, AppColors.lightBg],
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                    Container(
                      width: 60,
                      height: 1,
                      color: AppColors.gold,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  AppConstants.greeting,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                    Container(
                      width: 60,
                      height: 1,
                      color: AppColors.gold,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2),
                    gradient: RadialGradient(
                      colors: dark
                          ? [AppColors.darkCardAlt, AppColors.darkCard]
                          : [AppColors.lightCardAlt, AppColors.lightCard],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.gold.withOpacity(0.2),
                          blurRadius: 25,
                          spreadRadius: 2),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'ASMYA',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppConstants.appNameFull,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [AppColors.goldLight, AppColors.gold, AppColors.goldDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.role),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Start',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, color: Colors.black, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppConstants.footerBasmala,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
