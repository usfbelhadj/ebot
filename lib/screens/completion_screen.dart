// lib/screens/completion_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'english_levels_roadmap_screen.dart';

class CompletionScreen extends StatefulWidget {
  final String levelId;
  final String levelName;

  const CompletionScreen({
    super.key,
    required this.levelId,
    required this.levelName,
  });

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic> _levelStatus = {};
  
  @override
  void initState() {
    super.initState();
    _loadLevelStatus();
  }
  
  Future<void> _loadLevelStatus() async {
    try {
      final status = await _apiService.getLevelStatus(widget.levelId);
      setState(() {
        _levelStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C83),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Trophy icon
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    
                    // Congratulations text
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Level completion text
                    Text(
                      'You completed ${widget.levelName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Stats card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your Progress',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Correct answers
                          _buildStatRow(
                            'Correct Answers:',
                            '${_levelStatus['correctAnswers'] ?? 0}',
                          ),
                          const SizedBox(height: 10),
                          
                          // Total answers
                          _buildStatRow(
                            'Total Questions:',
                            '${_levelStatus['totalAnswers'] ?? 0}',
                          ),
                          const SizedBox(height: 10),
                          
                          // Level completion status
                          _buildStatRow(
                            'Level Status:',
                            _levelStatus['isCompleted'] == true
                                ? 'Completed'
                                : 'In Progress',
                            valueColor: _levelStatus['isCompleted'] == true
                                ? Colors.green
                                : Colors.amber,
                          ),
                          
                          // Next level unlocked status
                          if (_levelStatus['nextLevel'] != null) ...[
                            const SizedBox(height: 20),
                            Text(
                              'You\'ve unlocked ${_levelStatus['nextLevel']['name']}!',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Return to roadmap button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3B30),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        // Pop back to roadmap screen
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst || 
                              route.settings.name == '/roadmap',
                        );
                      },
                      child: const Text(
                        'Return to Roadmap',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}