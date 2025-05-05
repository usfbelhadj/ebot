import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/chat_bot_screen .dart';
import 'screens/vocabular_quiz_screen .dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';

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
        '/welcome': (context) => SignupScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => OtpScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/vocabulary-quiz':
            return MaterialPageRoute(
              builder: (context) => const VocabularyQuizScreen(),
            );
          case '/chat-bot':
            return MaterialPageRoute(builder: (context) => const ChatScreen());
          default:
            return null;
        }
      },
    );
  }
}
