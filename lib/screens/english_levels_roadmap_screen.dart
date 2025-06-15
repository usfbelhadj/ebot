// lib/screens/english_levels_roadmap_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/level.dart';
import 'question_screen.dart';

class EnglishLevelsRoadmapScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const EnglishLevelsRoadmapScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<EnglishLevelsRoadmapScreen> createState() =>
      _EnglishLevelsRoadmapScreenState();
}

class _EnglishLevelsRoadmapScreenState
    extends State<EnglishLevelsRoadmapScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Level> _levels = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final levels = await _apiService.getLevelsForCourse(widget.courseId);

      if (mounted) {
        setState(() {
          _levels = levels;
          _isLoading = false;

          // If no levels found, set an error message
          if (levels.isEmpty) {
            _error =
                'No levels found for this course. Make sure you have created levels in the backend.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load levels: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C83),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.courseName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Roadmap
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : _error != null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _loadLevels,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF3B30),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                        : SingleChildScrollView(child: _buildRoadmap(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmap(BuildContext context) {
    // Calculate total height based on the number of levels
    final double totalHeight = MediaQuery.of(context).size.height * 1.2;

    // Create level positions - calculate dynamically based on level order
    List<Map<String, dynamic>> levelPositions = [];

    for (int i = 0; i < _levels.length; i++) {
      // Create a zig-zag pattern for level positions
      double horizontalPosition = (i % 2 == 0) ? 0.3 : 0.7;
      double verticalPosition = (i + 1) / (_levels.length + 1);

      levelPositions.add({
        'level': _levels[i],
        'position': Offset(horizontalPosition, verticalPosition),
      });
    }

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: [
          // Road path connecting all levels
          CustomPaint(
            size: Size(double.infinity, totalHeight),
            painter: RoadPathPainter(levelPositions),
          ),

          // Level circles positioned along the road
          ...levelPositions.map((levelData) {
            Level level = levelData['level'] as Level;
            Offset position = levelData['position'] as Offset;

            // Calculate position based on the relative coordinates
            final double x =
                position.dx * (MediaQuery.of(context).size.width - 140);
            final double y = position.dy * totalHeight;

            return Positioned(
              left: x,
              top: y,
              child: _buildLevelCircle(context, level),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLevelCircle(BuildContext context, Level level) {
    return GestureDetector(
      onTap:
          level.isUnlocked
              ? () {
                // Navigate to the question screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => QuestionScreen(
                          levelId: level.id,
                          levelName: level.name,
                        ),
                  ),
                ).then((_) {
                  // Refresh levels when returning from question screen
                  _loadLevels();
                });
              }
              : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              level.isUnlocked
                  ? const Color.fromARGB(255, 230, 16, 5)
                  : Colors.grey.shade700,
          boxShadow: [
            BoxShadow(
              color:
                  level.isUnlocked
                      ? const Color(0xFFFF3B30).withOpacity(0.3)
                      : Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Level number
            Text(
              level.number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),

            // Lock icon for locked levels
            if (!level.isUnlocked)
              Positioned(
                bottom: 15,
                child: Icon(
                  Icons.lock,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
              ),

            // Play button for unlocked levels
            if (level.isUnlocked)
              const Positioned(
                bottom: 15,
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),

            // Unlock/lock status text
            Positioned(
              top: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      level.isUnlocked
                          ? (level.isCompleted ? Colors.green : Colors.blue)
                          : Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  level.isCompleted
                      ? 'COMPLETED'
                      : (level.isUnlocked ? 'OPEN' : 'LOCKED'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter to draw a winding road path connecting all levels
class RoadPathPainter extends CustomPainter {
  final List<Map<String, dynamic>> levelPositions;

  RoadPathPainter(this.levelPositions);

  @override
  void paint(Canvas canvas, Size size) {
    if (levelPositions.isEmpty) return;

    // Paint for the road (wider path)
    final roadPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 30
          ..strokeCap = StrokeCap.round;

    // Create path through all level positions
    final path = Path();

    // Get the first level position to start the path
    final firstPosition = levelPositions[0]['position'] as Offset;
    final startX = firstPosition.dx * size.width;
    final startY = firstPosition.dy * size.height;

    path.moveTo(startX, startY);

    // Connect all level positions with a smooth curve
    for (int i = 1; i < levelPositions.length; i++) {
      final position = levelPositions[i]['position'] as Offset;
      final prevPosition = levelPositions[i - 1]['position'] as Offset;

      final x = position.dx * size.width;
      final y = position.dy * size.height;
      final prevX = prevPosition.dx * size.width;
      final prevY = prevPosition.dy * size.height;

      // Control points for smooth curved road
      final controlX1 = prevX;
      final controlY1 = (prevY + y) / 2;
      final controlX2 = x;
      final controlY2 = (prevY + y) / 2;

      path.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
    }

    // Draw the road (wide path)
    canvas.drawPath(path, roadPaint);

    // Draw small circles for milestones along the road
    final milestonePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..style = PaintingStyle.fill;

    for (var levelData in levelPositions) {
      final position = levelData['position'] as Offset;
      final x = position.dx * size.width;
      final y = position.dy * size.height;

      canvas.drawCircle(Offset(x, y), 5, milestonePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
