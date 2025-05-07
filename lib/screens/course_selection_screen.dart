import 'package:flutter/material.dart';
import 'english_levels_roadmap_screen.dart';

class CourseSelectionScreen extends StatelessWidget {
  const CourseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF002C83,
      ), // Dark blue background matching the image
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              // Title text
              const Text(
                'Choose current\ncourse !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // General English Course button - now navigates to EnglishLevelsRoadmapScreen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the levels roadmap screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const EnglishLevelsRoadmapScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFFF3B30,
                    ), // Red color matching the image
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'General English Course',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Business English Course button
              _buildCourseButton(
                context: context,
                courseName: 'Business English Course',
              ),
              const SizedBox(height: 16),

              // Kids program button
              _buildCourseButton(context: context, courseName: 'Kids program'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create consistent course buttons
  Widget _buildCourseButton({
    required BuildContext context,
    required String courseName,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // For now, just print the button name
          print('Selected course: $courseName');

          // Show a snackbar to visually indicate the selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: $courseName (coming soon)'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFFFF3B30,
          ), // Red color matching the image
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          courseName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
