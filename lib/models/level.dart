// lib/models/level.dart
class Level {
  final String id;
  final int number;
  final String name;
  final String description;
  final int order;
  final bool isUnlocked;
  final bool isCompleted;
  final int correctAnswers;
  final int totalAnswers;
  
  Level({
    required this.id,
    required this.number,
    required this.name,
    required this.description,
    required this.order,
    required this.isUnlocked,
    required this.isCompleted,
    required this.correctAnswers,
    required this.totalAnswers,
  });
  
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['_id'],
      number: json['number'],
      name: json['name'],
      description: json['description'],
      order: json['order'],
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      correctAnswers: json['correctAnswers'] ?? 0,
      totalAnswers: json['totalAnswers'] ?? 0,
    );
  }
}