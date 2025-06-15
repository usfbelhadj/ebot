import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const Color kBrandColor = Color(0xFF8E44AD);

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp(BuildContext context, String email) async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      Fluttertoast.showToast(msg: "OTP is required.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Registration successful! Please login with your credentials.",
        );

        // Navigate to login screen and remove all previous routes
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Invalid OTP. Please try again.",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error verifying OTP.");
      print("OTP verification error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp(String email) async {
    print("Resending OTP to $email");
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "OTP resent successfully.");
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Failed to resend OTP. Please try again.",
        );
      }

      // If you want to implement resend OTP, you should create a separate endpoint
      // like POST /api/auth/resend-otp that only requires email
    } catch (e) {
      Fluttertoast.showToast(msg: "Network error. Please try again.");
      print("Resend OTP error: $e");
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
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Solid Background Color (matching signup)
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
                  'Verify OTP',
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
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Enter the 6-digit code sent to',
                          style: TextStyle(
                            color: Color(0xFFE30613),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        _buildOtpField(),
                        const SizedBox(height: 30),
                        _buildResendButton(email),
                      ],
                    ),
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
                      onPressed:
                          _isLoading ? null : () => _verifyOtp(context, email),
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
                                'Verify',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                    ),
                  ),
                ),

                // Back to Registration Link
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/signup',
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Back to Registration',
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

  Widget _buildOtpField() {
    return TextFormField(
      controller: otpController,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black87, fontSize: 18),
      maxLength: 6,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: 'Enter OTP',
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black26, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE30613), width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        counterText: "",
      ),
      cursorColor: Colors.white,
    );
  }

  Widget _buildResendButton(String email) {
    return TextButton(
      onPressed: _isLoading ? null : () => _resendOtp(email),
      child: Text(
        'Didn\'t receive the code? Resend OTP',
        style: TextStyle(
          color: Color(0xFFE30613),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black54.withOpacity(0.8),
        ),
      ),
    );
  }
}
