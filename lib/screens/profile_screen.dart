// lib/screens/profile_screen.dart
import 'package:ebot/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isNavigating = false; 
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      final response = await AuthService.getUserProfile();
      
      if (mounted) {
        setState(() {
          _userProfile = response['success'] ? response['data'] : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "Failed to load profile");
      }
    }
  }

  Future<void> _handleEditProfile() async {
    if (_userProfile == null || _isNavigating) {
      if (_userProfile == null) {
        Fluttertoast.showToast(msg: "Profile data not loaded yet.");
      }
      return;
    }
    
    setState(() {
      _isNavigating = true;
    });
    
    try {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(userProfile: _userProfile!),
        ),
      );
      
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
        
        if (result == true) {
          await _loadUserProfile();
          Fluttertoast.showToast(msg: "Profile refreshed");
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
        Fluttertoast.showToast(msg: "Error opening edit screen");
      }
    }
  }

  Future<void> _handleLogout() async {
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });
    
    try {
      await AuthService.logout();
      if (mounted) {
        Fluttertoast.showToast(msg: "Logged out successfully");
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
        Fluttertoast.showToast(msg: "Error logging out");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF002C83),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isNavigating 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF002C83),
                    ),
                  )
                : const Icon(Icons.edit, color: Color(0xFF002C83)),
            onPressed: _isNavigating ? null : _handleEditProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Failed to load profile',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _loadUserProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002C83),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile header
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF002C83),
                        child: Text(
                          _getInitials(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _userProfile!['fullName'] ??
                            '${_userProfile!['firstName']} ${_userProfile!['lastName']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF002C83),
                        ),
                      ),
                      Text(
                        _userProfile!['email'] ?? 'No email',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),

                      // Stats section
                      _buildStatsCard(),

                      const SizedBox(height: 30),

                      // Achievements section
                      _buildAchievementsCard(),

                      const SizedBox(height: 30),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isNavigating ? null : _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isNavigating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(width: 8),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  String _getInitials() {
    if (_userProfile == null) return '';
    final firstName = _userProfile!['firstName'] as String? ?? '';
    final lastName = _userProfile!['lastName'] as String? ?? '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002C83),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),

            // Points
            _buildStatRow(
              'Total Points',
              '${_userProfile!['points'] ?? 0}',
              Icons.stars,
              Colors.amber,
            ),

            // Trophies
            _buildStatRow(
              'Trophies',
              '${_userProfile!['trophies'] ?? 0}',
              Icons.emoji_events,
              Colors.orange,
            ),

            // Correct Answers
            _buildStatRow(
              'Correct Answers',
              '${_userProfile!['totalCorrectAnswers'] ?? 0}',
              Icons.check_circle,
              Colors.green,
            ),

            // Vocabulary correct
            _buildStatRow(
              'Vocabulary',
              '${(_userProfile!['correctAnswers'] ?? {})['vocabulary'] ?? 0}',
              Icons.book,
              Colors.blue,
              isSubStat: true,
            ),

            // Grammar correct
            _buildStatRow(
              'Grammar',
              '${(_userProfile!['correctAnswers'] ?? {})['grammar'] ?? 0}',
              Icons.edit,
              Colors.purple,
              isSubStat: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard() {
    // Calculate success rate
    final totalCorrect = _userProfile!['totalCorrectAnswers'] as int? ?? 0;
    final totalWrong = _userProfile!['totalWrongAnswers'] as int? ?? 0;
    final totalAnswers = totalCorrect + totalWrong;
    final successRate =
        totalAnswers > 0
            ? (totalCorrect / totalAnswers * 100).toStringAsFixed(1)
            : '0.0';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002C83),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),

            // Success Rate
            _buildStatRow(
              'Success Rate',
              '$successRate%',
              Icons.insights,
              Colors.teal,
            ),

            // Account Age
            _buildStatRow(
              'Days Learning',
              _getDaysLearning(),
              Icons.calendar_today,
              Colors.indigo,
            ),

            // Account creation date
            _buildStatRow(
              'Joined',
              _formatDate(_userProfile!['createdAt'] ?? ''),
              Icons.date_range,
              Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isSubStat = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isSubStat ? 20 : 0, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: isSubStat ? 18 : 24),
          SizedBox(width: isSubStat ? 8 : 12),
          Text(
            label,
            style: TextStyle(
              fontSize: isSubStat ? 14 : 16,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isSubStat ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getDaysLearning() {
    try {
      final createdAt = DateTime.parse(_userProfile!['createdAt'] ?? '');
      final now = DateTime.now();
      final difference = now.difference(createdAt);
      return '${difference.inDays}';
    } catch (e) {
      return '0';
    }
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return 'Unknown';
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}