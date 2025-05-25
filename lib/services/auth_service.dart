// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:5000/api'; // Android emulator
  // Use 'http://localhost:5000/api' for iOS simulator

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;

    // Validate token by making a request
    try {
      final response = await getUserProfile();
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Get token from shared preferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'Not authenticated'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> data,
  ) async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'Not authenticated'};
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Change password

  static Future<Map<String, dynamic>> changePassword(String newPassword) async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'Not authenticated'};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'new_password': newPassword}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Logout - clear token
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static updateProfile(Map<String, String> profileData) {}
}
