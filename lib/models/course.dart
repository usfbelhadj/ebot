// lib/models/course.dart
import 'package:flutter/material.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final String level;
  
  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
  });
  
  factory Course.fromJson(Map<String, dynamic> json) {
    try {
      return Course(
        id: json['_id'] ?? '',
        name: json['name'] ?? 'Unknown Course',
        description: json['description'] ?? 'No description available',
        level: json['level'] ?? 'Beginner',
      );
    } catch (e) {
      debugPrint('Error parsing Course: $e');
      debugPrint('Course JSON: $json');
      return Course(
        id: 'error',
        name: 'Error Loading Course',
        description: 'There was an error loading this course',
        level: 'Unknown',
      );
    }
  }
}