// lib/models/course.dart
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
    return Course(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      level: json['level'],
    );
  }
}