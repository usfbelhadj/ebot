import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_auth/email_auth.dart';
import 'package:http/http.dart' as http;

const Color kBrandColor = Color(0xFF8E44AD);

class OtpScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  OtpScreen({super.key});

  void _verifyOtp(BuildContext context, String email) async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      Fluttertoast.showToast(msg: "OTP is required.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/verify-otp'),
        body: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "OTP Verified!");
        Navigator.pushNamed(context, '/welcome');
      } else {
        Fluttertoast.showToast(msg: "Invalid OTP. Try again.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error verifying OTP.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Verify OTP',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    labelStyle: const TextStyle(color: Colors.black87),
                    prefixIcon: Icon(Icons.lock_outline, color: kBrandColor),
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
                ),
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
                      _verifyOtp(context, email);
                    },
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
