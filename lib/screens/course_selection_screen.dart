// lib/screens/course_selection_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/course.dart';
import 'english_levels_roadmap_screen.dart';

class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Course> _courses = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await _apiService.getCourses();
      print(courses);
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load courses. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C83),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                          onPressed: _loadCourses,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF3B30),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                  : Column(
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

                      // List of courses
                      ..._courses.map((course) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              EnglishLevelsRoadmapScreen(
                                                courseId: course.id,
                                                courseName: course.name,
                                              ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF3B30),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(
                                  course.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
        ),
      ),
    );
  }
}
