import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../data/providers/auth_provider.dart';
import '../core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2200), () async {
      final auth = context.read<AuthProvider>();
      if (!mounted) return;
      if (auth.user != null) {
        Navigator.of(context).pushReplacementNamed(AppRouter.main);
      } else {
        Navigator.of(context).pushReplacementNamed(AppRouter.welcome);
      }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

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
            radius: 1.2,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 3),
                    gradient: const RadialGradient(
                      colors: [AppColors.darkCard, AppColors.darkBg],
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 30, spreadRadius: 4),
                    ],
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppConstants.arabicName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('ASMYA',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                    )),
                const SizedBox(height: 8),
                Text(
                  AppConstants.appNameFull,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
