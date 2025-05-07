// lib/models/question.dart
class QuestionOption {
  final String id;
  final String text;
  final bool? isCorrect; // Only available after submission
  
  QuestionOption({
    required this.id,
    required this.text,
    this.isCorrect,
  });
  
  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['_id'],
      text: json['text'],
      isCorrect: json['isCorrect'],
    );
  }
}

class Question {
  final String id;
  final String text;
  final String type; // 'vocabulary' or 'grammar'
  final int difficultyRating;
  final List<QuestionOption> options;
  final String? explanation; // Available after submission
  final bool isPassed;
  
  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.difficultyRating,
    required this.options,
    this.explanation,
    this.isPassed = false,
  });
  
  factory Question.fromJson(Map<String, dynamic> json) {
    List<QuestionOption> optionsList = [];
    if (json['options'] != null) {
      optionsList = (json['options'] as List)
          .map((option) => QuestionOption.fromJson(option))
          .toList();
    }
    
    return Question(
      id: json['_id'],
      text: json['text'],
      type: json['type'],
      difficultyRating: json['difficultyRating'] ?? 1,
      options: optionsList,
      explanation: json['explanation'],
      isPassed: json['isPassed'] ?? false,
    );
  }
}