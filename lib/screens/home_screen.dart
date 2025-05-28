// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'chat_bot_screen .dart';
import 'course_selection_screen.dart';
import 'profile_screen.dart';
import 'sessions_screen.dart'; 

// Provider for the selected tab index
final selectedTabProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current tab index from provider
    final selectedIndex = ref.watch(selectedTabProvider);

    final List<Widget> screens = const [
      CourseSelectionScreen(),
      SessionsScreen(), 
      ChatScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Blue background matching other screens
          Container(color: const Color(0xFF002C83)),

          // Main content with IndexedStack
          SafeArea(
            child: Column(
              children: [
                // Top header with logo
                if (selectedIndex == 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // Logo
                        Image.asset('assets/images/logo-wbg.png', width: 120),
                        const SizedBox(height: 10),
                        // Welcome text
                        const Text(
                          'English Learning App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Content area with white background
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      child: IndexedStack(
                        index: selectedIndex,
                        children: screens,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF002C83),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        currentIndex: selectedIndex,
        onTap: (index) {
          // Update the selected index using Riverpod
          ref.read(selectedTabProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: selectedIndex == 0
                  ? BoxDecoration(
                      color: const Color(0xFF002C83).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Icon(
                selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 22,
              ),
            ),
            label: 'Learn',
          ),
          
          // Sessions Tab
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: selectedIndex == 1
                  ? BoxDecoration(
                      color: const Color(0xFF002C83).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Stack(
                children: [
                  Icon(
                    selectedIndex == 1 ? Icons.live_tv : Icons.live_tv_outlined,
                    size: 22,
                  ),
                  // Live indicator dot
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            label: 'Sessions',
          ),
          
          // Chat Tab
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: selectedIndex == 2
                  ? BoxDecoration(
                      color: const Color(0xFF002C83).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Icon(
                selectedIndex == 2 ? Icons.smart_toy : Icons.smart_toy_outlined,
                size: 22,
              ),
            ),
            label: 'Chat',
          ),
          
          // Profile Tab
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: selectedIndex == 3
                  ? BoxDecoration(
                      color: const Color(0xFF002C83).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Icon(
                selectedIndex == 3 ? Icons.person : Icons.person_outline,
                size: 22,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}