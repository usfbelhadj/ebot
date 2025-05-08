// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/level.dart';
import '../models/question.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5000/api'; // For Android emulator
  // Use 'http://localhost:5000/api' for iOS simulator

  // Get auth token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    return prefs.getString('token');
  }

  // Set auth token in shared preferences
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    print(token);
    await prefs.setString('token', token);
  }

  // Headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    // final token = await getToken();
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4MWJiNTgyYjk5MjM4NjlkYWMwNWZjMSIsImlhdCI6MTc0NjY1MzQ3OSwiZXhwIjoxNzQ5MjQ1NDc5fQ.4FrLgOFE8gDVfNt1rzD2X_XbGm7DPWrKz7EaLnxIRyA";
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Login user
  Future<bool> login(String username, String password) async {
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
    return false;
  }

  // Get all courses
  Future<List<Course>> getCourses() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/courses'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((courseJson) => Course.fromJson(courseJson))
            .toList();
      }
    }
    return [];
  }

  // Get levels for a course
  Future<List<Level>> getLevelsForCourse(String courseId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/levels/course/$courseId'),
      headers: headers,
    );

    // print url
    print(Uri.parse('$baseUrl/levels/course/$courseId'));
    // print headers
    print(headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((levelJson) => Level.fromJson(levelJson))
            .toList();
      }
    }

    return [];
  }

  // Get questions for a level
  Future<List<Question>> getQuestionsForLevel(String levelId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/questions/level/$levelId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((questionJson) => Question.fromJson(questionJson))
            .toList();
      }
    }
    return [];
  }

  // Submit answer for a question
  Future<Map<String, dynamic>> submitAnswer(
    String questionId,
    String optionId,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/questions/$questionId/answer'),
      headers: headers,
      body: jsonEncode({'optionId': optionId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      if (data['success'] && data['data'] != null) {
        return data['data'];
      }
    }
    return {};
  }

  // Get level completion status
  Future<Map<String, dynamic>> getLevelStatus(String levelId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/progress/level/$levelId/status'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data['success'] && data['data'] != null) {
        return data['data'];
      }
    }
    return {};
  }
}
