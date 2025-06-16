// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/level.dart';
import '../models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl =
      'https://3e16-165-50-112-219.ngrok-free.app/api'; // For Android emulator
  // Use 'http://10.0.2.2:5000/api' for iOS simulator
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Get auth token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Set auth token in shared preferences
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Login user
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] && data['token'] != null) {
          await setToken(data['token']);
          return true;
        }
      }
      debugPrint('Login failed: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // Get all courses
  Future<List<Course>> getCourses() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/courses'),
        headers: headers,
      );

      debugPrint('GET Courses Status: ${response.statusCode}');
      debugPrint('GET Courses Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] && data['data'] != null) {
          return (data['data'] as List)
              .map((courseJson) => Course.fromJson(courseJson))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getting courses: $e');
      return [];
    }
  }

  // Get levels for a course
  Future<List<Level>> getLevelsForCourse(String courseId) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/levels/course/$courseId');

      debugPrint('GET Levels URL: $uri');

      final response = await http.get(uri, headers: headers);

      debugPrint('GET Levels Status: ${response.statusCode}');
      debugPrint('GET Levels Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] && data['data'] != null) {
          return (data['data'] as List)
              .map((levelJson) => Level.fromJson(levelJson))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getting levels: $e');
      return [];
    }
  }

  // Get questions for a level
  Future<List<Question>> getQuestionsForLevel(String levelId) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/questions/level/$levelId');

      debugPrint('GET Questions URL: $uri');

      final response = await http.get(uri, headers: headers);

      debugPrint('GET Questions Status: ${response.statusCode}');
      debugPrint('GET Questions Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] && data['data'] != null) {
          return (data['data'] as List)
              .map((questionJson) => Question.fromJson(questionJson))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getting questions: $e');
      return [];
    }
  }

  // Submit answer for a question
  Future<Map<String, dynamic>> submitAnswer(
    String questionId,
    String optionId,
  ) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/questions/$questionId/answer');

      debugPrint('POST Answer URL: $uri');
      debugPrint('POST Answer Body: {"optionId": "$optionId"}');

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({'optionId': optionId}),
      );

      debugPrint('POST Answer Status: ${response.statusCode}');
      debugPrint('POST Answer Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] && data['data'] != null) {
          return data['data'];
        }
      }
      return {};
    } catch (e) {
      debugPrint('Error submitting answer: $e');
      return {};
    }
  }

  // Get level completion status
  Future<Map<String, dynamic>> getLevelStatus(String levelId) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/progress/level/$levelId/status');

      debugPrint('GET Level Status URL: $uri');

      final response = await http.get(uri, headers: headers);

      debugPrint('GET Level Status Status: ${response.statusCode}');
      debugPrint('GET Level Status Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] && data['data'] != null) {
          return data['data'];
        }
      }
      return {};
    } catch (e) {
      debugPrint('Error getting level status: $e');
      return {};
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(
    Map<String, String> profileData,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: headers,
        body: jsonEncode(profileData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword(
    Map<String, String> passwordData,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/users/change-password'),
        headers: headers,
        body: jsonEncode(passwordData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Update username
  Future<void> updateUsername(String username) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/users/username'),
        headers: headers,
        body: jsonEncode({'username': username}),
      );

      debugPrint('Update Username Status: ${response.statusCode}');
      debugPrint('Update Username Response: ${response.body}');

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to update username');
      }
    } catch (e) {
      debugPrint('Error updating username: $e');
      throw Exception('Failed to update username: $e');
    }
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Logout
  static Future<void> logout() async {
    await removeToken();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
