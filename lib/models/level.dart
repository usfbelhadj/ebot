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
    // More robust parsing with better null handling
    try {
      return Level(
        id: json['_id'] ?? '',
        number: json['number'] ?? 1,
        name: json['name'] ?? 'Unknown Level',
        description: json['description'] ?? '',
        order: json['order'] ?? 1,
        isUnlocked: json['isUnlocked'] ?? false,
        isCompleted: json['isCompleted'] ?? false,
        correctAnswers: json['correctAnswers'] ?? 0,
        totalAnswers: json['totalAnswers'] ?? 0,
      );
    } catch (e) {
      print('Error parsing Level from JSON: $e');
      print('JSON data: $json');
      // Return a default level object in case of parsing errors
      return Level(
        id: json['_id'] ?? 'error',
        number: 0,
        name: 'Error Loading Level',
        description: 'There was an error loading this level',
        order: 0,
        isUnlocked: false,
        isCompleted: false,
        correctAnswers: 0,
        totalAnswers: 0,
      );
    }
  }
}