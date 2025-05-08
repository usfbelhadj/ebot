// lib/models/question.dart
import 'package:flutter/material.dart';

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
    try {
      return QuestionOption(
        id: json['_id'] ?? '',
        text: json['text'] ?? 'Unknown Option',
        isCorrect: json['isCorrect'],
      );
    } catch (e) {
      debugPrint('Error parsing QuestionOption: $e');
      debugPrint('Option JSON: $json');
      return QuestionOption(
        id: 'error',
        text: 'Error loading option',
      );
    }
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
    try {
      List<QuestionOption> optionsList = [];
      
      if (json['options'] != null) {
        optionsList = (json['options'] as List)
            .map((option) => QuestionOption.fromJson(option))
            .toList();
      }
      
      return Question(
        id: json['_id'] ?? '',
        text: json['text'] ?? 'Unknown Question',
        type: json['type'] ?? 'vocabulary',
        difficultyRating: json['difficultyRating'] ?? 1,
        options: optionsList,
        explanation: json['explanation'],
        isPassed: json['isPassed'] ?? false,
      );
    } catch (e) {
      debugPrint('Error parsing Question: $e');
      debugPrint('Question JSON: $json');
      
      // Return a default question with an error message
      return Question(
        id: 'error',
        text: 'Error loading question',
        type: 'vocabulary',
        difficultyRating: 1,
        options: [
          QuestionOption(id: 'error', text: 'Error loading options')
        ],
        isPassed: false,
      );
    }
  }
}