import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/course_selection_screen.dart';

void main() {
  runApp(const ProviderScope(child: EbotApp()));
}

class EbotApp extends StatelessWidget {
  const EbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebot',
      theme: buildThemeData(), // defined in core/theme.dart
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => OtpScreen(),
        '/home': (context) => const HomeScreen(), // Add the new HomeScreen route
      },
    );
  }
}