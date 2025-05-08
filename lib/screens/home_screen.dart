// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'chat_bot_screen .dart';
import 'course_selection_screen.dart';
import 'profile_screen.dart'; // Add this import

// Provider for the selected tab index
final selectedTabProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current tab index from provider
    final selectedIndex = ref.watch(selectedTabProvider);

    // List of screens to display - now with profile screen
    final List<Widget> screens = const [
      CourseSelectionScreen(),
      ChatScreen(),
      ProfileScreen(), // Changed from EmptyScreen
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

  // Method to build the bottom navigation bar
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
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Learn'),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          label: 'Chat',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}