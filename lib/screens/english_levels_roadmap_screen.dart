import 'package:flutter/material.dart';
import 'vocabular_quiz_screen .dart';

class EnglishLevelsRoadmapScreen extends StatelessWidget {
  const EnglishLevelsRoadmapScreen({super.key});

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
                  const Expanded(
                    child: Text(
                      'General English Course',
                      style: TextStyle(
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
                child: SingleChildScrollView(child: _buildRoadmap(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmap(BuildContext context) {
    // List of level data (level number, unlock status)
    final levels = [
      {'level': 1, 'unlocked': true, 'position': const Offset(0.5, 0.1)},
      {'level': 2, 'unlocked': false, 'position': const Offset(0.8, 0.2)},
      {'level': 3, 'unlocked': false, 'position': const Offset(0.3, 0.3)},
      {'level': 4, 'unlocked': false, 'position': const Offset(0.6, 0.4)},
      {'level': 5, 'unlocked': false, 'position': const Offset(0.2, 0.5)},
      {'level': 6, 'unlocked': false, 'position': const Offset(0.7, 0.6)},
      {'level': 7, 'unlocked': false, 'position': const Offset(0.4, 0.7)},
      {'level': 8, 'unlocked': false, 'position': const Offset(0.7, 0.8)},
      {'level': 9, 'unlocked': false, 'position': const Offset(0.3, 0.9)},
      {'level': 10, 'unlocked': false, 'position': const Offset(0.5, 1.0)},
    ];

    // Calculate total height based on the number of levels
    final double totalHeight = MediaQuery.of(context).size.height * 1.2;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: [
          // Road path connecting all levels
          CustomPaint(
            size: Size(double.infinity, totalHeight),
            painter: RoadPathPainter(levels),
          ),

          // Level circles positioned along the road
          ...levels.map((level) {
            bool isUnlocked = level['unlocked'] as bool;
            int levelNumber = level['level'] as int;
            Offset position = level['position'] as Offset;

            // Calculate position based on the relative coordinates
            final double x =
                position.dx * (MediaQuery.of(context).size.width - 140);
            final double y = position.dy * totalHeight;

            return Positioned(
              left: x,
              top: y,
              child: _buildLevelCircle(context, levelNumber, isUnlocked),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLevelCircle(BuildContext context, int level, bool isUnlocked) {
    return GestureDetector(
      onTap:
          isUnlocked
              ? () {
                // Navigate to vocabulary quiz screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VocabularyQuizScreen(),
                  ),
                );
              }
              : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isUnlocked ? const Color(0xFFFF3B30) : Colors.grey.shade700,
          boxShadow: [
            BoxShadow(
              color:
                  isUnlocked
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
              level.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),

            // Lock icon for locked levels
            if (!isUnlocked)
              Positioned(
                bottom: 15,
                child: Icon(
                  Icons.lock,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
              ),

            // Play button for unlocked levels
            if (isUnlocked)
              Positioned(
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
                  color: isUnlocked ? Colors.green : Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isUnlocked ? 'OPEN' : 'LOCKED',
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
  final List<Map<String, dynamic>> levels;

  RoadPathPainter(this.levels);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the road (wider path)
    final roadPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 30
          ..strokeCap = StrokeCap.round;

    // Paint for the road markings (dashed line in the middle)
    final markingsPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    // Create path through all level positions
    final path = Path();

    // Get the first level position to start the path
    if (levels.isEmpty) return;

    final firstPosition = levels[0]['position'] as Offset;
    final startX = firstPosition.dx * size.width;
    final startY = firstPosition.dy * size.height;

    path.moveTo(startX, startY);

    // Connect all level positions with a smooth curve
    for (int i = 1; i < levels.length; i++) {
      final position = levels[i]['position'] as Offset;
      final prevPosition = levels[i - 1]['position'] as Offset;

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

    // Draw road markings (dashed center line)
    // Using dash pattern for the center line
    final dashPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    // Draw small circles for milestones along the road
    final milestonePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..style = PaintingStyle.fill;

    for (var level in levels) {
      final position = level['position'] as Offset;
      final x = position.dx * size.width;
      final y = position.dy * size.height;

      canvas.drawCircle(Offset(x, y), 5, milestonePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
