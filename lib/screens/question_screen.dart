// lib/screens/question_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/question.dart';
import 'completion_screen.dart';

class QuestionScreen extends StatefulWidget {
  final String levelId;
  final String levelName;

  const QuestionScreen({
    super.key,
    required this.levelId,
    required this.levelName,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  String? _selectedOptionId;
  bool _showingFeedback = false;
  bool _isCorrect = false;
  String? _explanation;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final questions = await _apiService.getQuestionsForLevel(widget.levelId);
      
      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoading = false;
          
          // If no questions found, set an error message
          if (questions.isEmpty) {
            _error = 'No questions found for this level. Make sure you have created questions in the backend.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load questions: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitAnswer() async {
    if (_selectedOptionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer'))
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      
      final result = await _apiService.submitAnswer(
        _questions[_currentQuestionIndex].id,
        _selectedOptionId!,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _showingFeedback = true;
          _isCorrect = result['isCorrect'] ?? false;
          _explanation = result['explanation'] ?? 'No explanation available';
        });
      }

      // Show feedback for 2 seconds before moving to next question
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showingFeedback = false;
            _selectedOptionId = null;

            // Move to next question or completion screen
            if (_currentQuestionIndex < _questions.length - 1) {
              _currentQuestionIndex++;
            } else {
              // Navigate to completion screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletionScreen(
                    levelId: widget.levelId,
                    levelName: widget.levelName,
                  ),
                ),
              );
            }
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting answer: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF002C83)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _questions.isNotEmpty && _currentQuestionIndex < _questions.length 
              ? '${_questions[_currentQuestionIndex].type.toUpperCase()} Quiz'
              : "Quiz",
          style: const TextStyle(
            color: Color(0xFF002C83),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        _error!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadQuestions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002C83),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _questions.isEmpty
              ? const Center(
                  child: Text('No questions available for this level'),
                )
              : Padding(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      // Progress indicator
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style: const TextStyle(
                          color: Color(0xFF002C83),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      LinearProgressIndicator(
                        value: (_currentQuestionIndex + 1) / _questions.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF002C83),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      // Question type indicator
                      Text(
                        _questions[_currentQuestionIndex].type == 'vocabulary'
                            ? 'Choose the correct vocabulary word'
                            : 'Complete the sentence with the correct grammar',
                        style: const TextStyle(
                          color: Color(0xFF002C83),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      // Question text
                      Text(
                        _questions[_currentQuestionIndex].text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      // Options grid
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: screenWidth * 0.05,
                            runSpacing: screenHeight * 0.02,
                            alignment: WrapAlignment.center,
                            children: _questions[_currentQuestionIndex].options.map((option) {
                              final isSelected = _selectedOptionId == option.id;
                              return GestureDetector(
                                onTap: _showingFeedback
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedOptionId = option.id;
                                        });
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: screenWidth * 0.4,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF002C83)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF002C83)
                                          : Colors.redAccent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      option.text,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Feedback area
                      if (_showingFeedback)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isCorrect
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _isCorrect ? 'Correct!' : 'Incorrect',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isCorrect
                                      ? Colors.green[800]
                                      : Colors.red[800],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _explanation ?? '',
                                style: TextStyle(
                                  color: _isCorrect
                                      ? Colors.green[800]
                                      : Colors.red[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF002C83),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                          ),
                          onPressed: _submitAnswer,
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
      ),
    );
  }
}