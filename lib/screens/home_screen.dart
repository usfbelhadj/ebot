import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'chat_bot_screen .dart';
import 'course_selection_screen.dart';

// Provider for the selected tab index
final selectedTabProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current tab index from provider
    final selectedIndex = ref.watch(selectedTabProvider);

    // List of screens to display - now with only 3 screens
    final List<Widget> screens = const [
      CourseSelectionScreen(),
      ChatScreen(),
      EmptyScreen(message: "Profile Screen - Coming Soon"),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: _buildBottomNavigationBar(
        context,
        ref,
        selectedIndex,
      ),
    );
  }

  // Method to build the bottom navigation bar - now with only 3 buttons
  Widget _buildBottomNavigationBar(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
  ) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF002C83),
      unselectedItemColor: Colors.grey,
      currentIndex: selectedIndex,
      onTap: (index) {
        // Update the selected index using Riverpod
        ref.read(selectedTabProvider.notifier).state = index;
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }
}

// Simple placeholder for empty screens
class EmptyScreen extends StatelessWidget {
  final String message;

  const EmptyScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Color(0xFF002C83),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
