// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const Color kBrandColor = Color(0xFF8E44AD); // Custom brand purple

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
    if (firstName.isEmpty || lastName.isEmpty || username.isEmpty || 
        email.isEmpty || password.isEmpty) {
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

      if (response.statusCode == 201 && data['success'] && data['token'] != null) {
        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        
        Fluttertoast.showToast(msg: "Registration successful!");
        
        // Navigate to OTP screen if needed, or directly to home
        if (mounted) {
          Navigator.pushNamed(context, '/otp', arguments: email);
        }
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Registration failed. Please try again.",
        );
      }
    } catch (e) {
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
                      onPressed: _isLoading ? null : _handleSignup,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
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
        _buildInputField('First Name', Icons.person_outline, controller: firstNameController),
        const SizedBox(height: 16),
        _buildInputField('Last Name', Icons.person_outline, controller: lastNameController),
        const SizedBox(height: 16),
        _buildInputField('Username', Icons.account_circle_outlined, controller: usernameController),
        const SizedBox(height: 16),
        _buildInputField('Email', Icons.email_outlined, controller: emailController),
        const SizedBox(height: 16),
        _buildInputField('Password', Icons.lock_outline, isPassword: true, controller: passwordController),
        const SizedBox(height: 16),
        _buildInputField('Confirm Password', Icons.lock_outline, isPassword: true, controller: confirmPasswordController),
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