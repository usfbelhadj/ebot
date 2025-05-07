import 'package:flutter/material.dart';

class VocabularyQuizScreen extends StatefulWidget {
  const VocabularyQuizScreen({super.key});

  @override
  State<VocabularyQuizScreen> createState() => _VocabularyQuizScreenState();
}

class _VocabularyQuizScreenState extends State<VocabularyQuizScreen> {
  String? selectedAnswer;

  final List<String> options = ['Book', 'Chair', 'Phone', 'Bag'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.06), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              const Text(
                'Complete the sentences\nwith the correct vocabulary word',
                style: TextStyle(
                  color: Color(0xFF002C83),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05), // Responsive spacing
              const Text(
                'I have a ____ on my desk.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05), // Responsive spacing
              // Options grid
              Wrap(
                spacing: screenWidth * 0.05, // Responsive spacing
                runSpacing: screenHeight * 0.02,
                alignment: WrapAlignment.center,
                children:
                    options.map((option) {
                      final isSelected = selectedAnswer == option;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAnswer = option;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: screenWidth * 0.4, // Responsive width
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF002C83)
                                    : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF002C83)
                                      : Colors.redAccent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow:
                                isSelected
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
                              option,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              SizedBox(height: screenHeight * 0.05), // Responsive spacing

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF002C83),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/chat-bot', // Change this to the correct route
                  ); // or wherever you're navigating
                },
                child: const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: const Color(0xFF002C83),
      //   unselectedItemColor: Colors.redAccent,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.smart_toy_outlined),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.emoji_events_outlined),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      //   ],
      //   currentIndex: 1,
      //   onTap: (index) {
      //     // Handle navigation here
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      // ),
    );
  }
}
