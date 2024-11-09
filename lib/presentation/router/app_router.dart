import 'package:flutter/material.dart';

import '../screens/car_details_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/forgot_password_token_screen.dart';
import '../screens/income_expense_screen.dart';
import '../screens/login_and_security_screen.dart';
import '../screens/main_screen.dart';
import '../screens/personal_profile_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/sign_up_screen.dart';
import '../screens/take_picture_screen.dart';
import '../screens/take_profile_picture_screen.dart';
import '../screens/welcome_screen.dart';

class AppRouter {
  // TODO: create final bloc / cubit instance here

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/main-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const MainScreen(),
        );
      case '/income-expense-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const IncomeExpenseScreen(),
        );
      case '/take-picture-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const TakePictureScreen(),
        );
      case '/sign-in-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SignInScreen(),
        );
      case '/sign-up-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SignUpScreen(),
        );
      case '/forgot-password-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ForgotPasswordScreen(),
        );
      case '/forgot-password-token-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ForgotPasswordTokenScreen(),
        );
      case '/car-details-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const CarDetailsScreen(),
        );
      case '/login-and-security-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const LoginAndSecurityScreen(),
        );
      case '/personal-profile-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const PersonalProfileScreen(),
        );
      case '/take-profile-picture-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const TakeProfilePictureScreen(),
        );
      case '/welcome-screen':
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const WelcomeScreen(),
        );
      default:
        return null;
    }
  }

  void dispose() {
    // TODO: close bloc / cubit instance here by calling close method of that instance
  }
}
