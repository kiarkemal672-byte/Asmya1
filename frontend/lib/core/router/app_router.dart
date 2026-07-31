import 'package:flutter/material.dart';
import '../../screens/splash_screen.dart';
import '../../screens/welcome_screen.dart';
import '../../screens/role_selection_screen.dart';
import '../../screens/gender_selection_screen.dart';
import '../../screens/sign_in_screen.dart';
import '../../screens/main_navigation_screen.dart';

class AppRouter {
  static const splash = '/';
  static const welcome = '/welcome';
  static const role = '/role';
  static const gender = '/gender';
  static const signIn = '/sign-in';
  static const main = '/main';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case role:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case gender:
        final role = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => GenderSelectionScreen(role: role));
      case signIn:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SignInScreen(
            role: args?['role'] as String?,
            side: args?['side'] as String?,
          ),
        );
      case main:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
