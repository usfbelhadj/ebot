// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quicklish/screens/english_levels_roadmap_screen.dart';
import 'core/theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/course_selection_screen.dart';
import 'screens/profile_screen.dart'; // Add this import
import 'services/auth_service.dart'; // Add this import
import 'screens/intro_screen.dart';

void main() {
  runApp(const ProviderScope(child: EbotApp()));
}

class EbotApp extends StatefulWidget {
  const EbotApp({super.key});

  @override
  State<EbotApp> createState() => _EbotAppState();
}

class _EbotAppState extends State<EbotApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quicklish',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(), // defined in core/theme.dart
      home:
          _isLoading
              ? const _SplashScreen() // Show splash screen while checking auth
              : _isLoggedIn
              ? const HomeScreen() // Go to home if logged in
              : const WelcomeScreen(), // Go to welcome if not logged in
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/intro': (context) => const RobertIntroScreen(),
        '/signup': (context) => const SignupScreen(),
        '/otp': (context) => OtpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(), // Add profile route
        '/course-selection': (context) => const CourseSelectionScreen(),
      },
    );
  }
}

// Simple splash screen while checking auth status
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C83),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo could go here
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
