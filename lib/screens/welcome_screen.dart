import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Dark blue
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Centered at the Top
                Center(child: Image.asset('assets/images/logo-bg.png')),
                SizedBox(height: 20),

                const Text(
                  'Your Fast Track to Fluent English',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF002C83),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                // "Next" button - now navigates to the HomeScreen
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE30613),
                    foregroundColor: Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the HomeScreen instead of vocabulary-quiz
                    Navigator.pushReplacementNamed(context, '/intro');
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
