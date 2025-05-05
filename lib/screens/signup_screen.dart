import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For showing toast messages
import 'package:email_auth/email_auth.dart'; // For email OTP authentication
import 'package:http/http.dart' as http; // For making HTTP requests

const Color kBrandColor = Color(0xFF8E44AD); // Custom brand purple

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  // Add other controllers if needed

  void _handleSignup(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Email cannot be empty.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:3000/send-otp'),
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "OTP sent to your email!");
        Navigator.pushNamed(context, '/otp', arguments: email);
      } else {
        Fluttertoast.showToast(msg: "Failed to send OTP. Try again.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Network error. Failed to send OTP.");
    }
  }

  void _handleotp(BuildContext context) {
    // Simulate OTP verification
    try {
      http
          .post(
            Uri.parse('http://localhost:3000/send-otp'),
            body: {'email': 'usf.belhadj@gmail.com'},
          )
          .then((response) {
            if (response.statusCode == 200) {
              Fluttertoast.showToast(msg: "OTP sent to your email!");
              Navigator.pushNamed(context, '/otp');
            } else {
              Fluttertoast.showToast(msg: "Failed to send OTP. Try again.");
            }
          });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to send OTP. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      'assets/images/logo-wbg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSignupForm(),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBrandColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                      onPressed: () {
                        _handleSignup(context);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Already have an account? Log In',
                      style: TextStyle(
                        color: kBrandColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    return Column(
      children: [
        _buildInputField('First Name', Icons.person_outline),
        const SizedBox(height: 16),
        _buildInputField('Last Name', Icons.person_outline),
        const SizedBox(height: 16),
        _buildInputField('Username', Icons.account_circle_outlined),
        const SizedBox(height: 16),
        _buildInputField(
          'Email',
          Icons.email_outlined,
          controller: emailController,
        ),
        const SizedBox(height: 16),
        _buildInputField('Password', Icons.lock_outline, isPassword: true),
        const SizedBox(height: 16),
        _buildInputField(
          'Confirm Password',
          Icons.lock_outline,
          isPassword: true,
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,

      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: kBrandColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kBrandColor),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
      cursorColor: kBrandColor,
    );
  }
}
