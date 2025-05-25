// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const Color kBrandColor = Color(0xFF8E44AD); // Custom brand purple

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // In development, we'll prefill with test credentials
    usernameController.text = '';
    passwordController.text = '';
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Username and password are required.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      debugPrint('Login Response Status: ${response.statusCode}');
      debugPrint('Login Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['token'] != null) {
        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);

        if (mounted) {
          // Show success message
          Fluttertoast.showToast(msg: "Login successful!");

          // Navigate to home screen
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Invalid credentials. Please try again.",
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Fluttertoast.showToast(msg: "Network error. Please try again.");
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
      body: Stack(
        children: [
          // Solid Background Color (matching signup)
          Container(color: const Color(0xFF002C83)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo Centered at the Top
                Center(
                  child: Image.asset('assets/images/logo-wbg.png', width: 140),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildLoginForm(),
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
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF002C83),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF002C83),
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Log In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                    ),
                  ),
                ),

                // Signup Link
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(
                        color: Colors.white,
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

  Widget _buildLoginForm() {
    return Column(
      children: [
        const SizedBox(height: 40),
        _buildInputField(
          'Username',
          Icons.person_outline,
          controller: usernameController,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          'Password',
          Icons.lock_outline,
          isPassword: true,
          controller: passwordController,
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon, {
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
      cursorColor: Colors.white,
    );
  }
}
