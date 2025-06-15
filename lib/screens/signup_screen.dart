// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
    });

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Basic validation
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: "Passwords do not match.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      // Check for status code 200 which indicates successful registration
      // but pending OTP verification as per our updated backend
      if (response.statusCode == 200 && data['email'] != null) {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Please verify your email with the OTP sent.",
        );

        // Navigate to OTP verification screen with the email
        if (mounted) {
          Navigator.pushNamed(context, '/otp', arguments: email);
        }
      } else {
        // Handle registration errors
        Fluttertoast.showToast(
          msg: data['message'] ?? "Registration failed. Please try again.",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Network error. Please try again.");
      print("Registration error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Solid Background Color
          Container(color: const Color.fromARGB(255, 255, 255, 255)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo Centered at the Top
                Center(
                  child: Image.asset('assets/images/logo-bg.png', width: 140),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    color: Color(0xFF002C83),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildSignupForm(),
                  ),
                ),

                // Bottom Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE30613),
                        foregroundColor: Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleSignup,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                // Login Link
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Already have an account? Log In',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Column(
      children: [
        _buildInputField(
          'First Name',
          Icons.person_outline,
          controller: firstNameController,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          'Last Name',
          Icons.person_outline,
          controller: lastNameController,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          'Username',
          Icons.account_circle_outlined,
          controller: usernameController,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          'Email',
          Icons.email_outlined,
          controller: emailController,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          'Password',
          Icons.lock_outline,
          isPassword: true,
          controller: passwordController,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          'Confirm Password',
          Icons.lock_outline,
          isPassword: true,
          controller: confirmPasswordController,
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
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.shade100, // subtle light background
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE30613), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
      cursorColor: const Color(0xFF002C83),
    );
  }
}
