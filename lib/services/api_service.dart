// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/level.dart';
import '../models/question.dart';
import 'package:flutter/material.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5000/api'; // For Android emulator
  // Use 'http://localhost:5000/api' for iOS simulator

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
      
      final response = await http.get(
        uri,
        headers: headers,
      );

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
      
      final response = await http.get(
        uri,
        headers: headers,
      );

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
      
      final response = await http.get(
        uri,
        headers: headers,
      );

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
}