// lib/screens/sessions_screen.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isJoining = false;

  // Static data for live sessions
  final List<LearningSession> _liveSessions = [
    LearningSession(
      id: '1',
      title: 'Advanced Grammar Workshop',
      instructor: 'Amina Bensalah',
      participants: 15,
      maxParticipants: 20,
      startTime: DateTime.now().subtract(const Duration(minutes: 10)),
      endTime: DateTime.now().add(const Duration(minutes: 50)),
      level: 'Intermediate',
      topic: 'Grammar',
      isLive: true,
    ),
    LearningSession(
      id: '2',
      title: 'Vocabulary Building Session',
      instructor: 'Mohamed Khelifi',
      participants: 8,
      maxParticipants: 15,
      startTime: DateTime.now().subtract(const Duration(minutes: 5)),
      endTime: DateTime.now().add(const Duration(minutes: 25)),
      level: 'Beginner',
      topic: 'Vocabulary',
      isLive: true,
    ),
    LearningSession(
      id: '3',
      title: 'English Pronunciation Lab',
      instructor: 'Nesrine Trabelsi',
      participants: 12,
      maxParticipants: 18,
      startTime: DateTime.now().subtract(const Duration(minutes: 20)),
      endTime: DateTime.now().add(const Duration(minutes: 40)),
      level: 'All Levels',
      topic: 'Pronunciation',
      isLive: true,
    ),
  ];

  // Static data for upcoming sessions
  final List<LearningSession> _upcomingSessions = [
    LearningSession(
      id: '4',
      title: 'English Conversation Practice',
      instructor: 'Youssef Hamdi',
      participants: 12,
      maxParticipants: 18,
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      level: 'All Levels',
      topic: 'Conversation',
      isLive: false,
    ),
    LearningSession(
      id: '5',
      title: 'Business English Basics',
      instructor: 'Khaled Ben Ahmed',
      participants: 6,
      maxParticipants: 12,
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5, minutes: 30)),
      level: 'Intermediate',
      topic: 'Business',
      isLive: false,
    ),
    LearningSession(
      id: '6',
      title: 'IELTS Speaking Prep',
      instructor: 'Mariem Jebali',
      participants: 9,
      maxParticipants: 15,
      startTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      level: 'Advanced',
      topic: 'Test Prep',
      isLive: false,
    ),
    LearningSession(
      id: '7',
      title: 'Creative Writing Workshop',
      instructor: 'Amine Bouaziz',
      participants: 5,
      maxParticipants: 10,
      startTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      endTime: DateTime.now().add(
        const Duration(days: 1, hours: 4, minutes: 30),
      ),
      level: 'Intermediate',
      topic: 'Writing',
      isLive: false,
    ),
    LearningSession(
      id: '8',
      title: 'American vs British English',
      instructor: 'Sonia Gharbi',
      participants: 14,
      maxParticipants: 20,
      startTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      level: 'All Levels',
      topic: 'Culture',
      isLive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _joinSession(LearningSession session) async {
    if (_isJoining) return;

    setState(() => _isJoining = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isJoining = false);

      if (session.isLive) {
        Fluttertoast.showToast(
          msg: "Joining ${session.title}...",
          toastLength: Toast.LENGTH_SHORT,
        );
        // In a real app, you'd navigate to video call screen here
      } else {
        Fluttertoast.showToast(
          msg: "Registered for ${session.title}!",
          toastLength: Toast.LENGTH_SHORT,
        );
        // Update participant count locally
        setState(() {
          session.participants = session.participants + 1;
        });
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
          'Learning Sessions',
          style: TextStyle(
            color: Color(0xFF002C83),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF002C83),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF002C83),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.live_tv, size: 18),
                  const SizedBox(width: 8),
                  Text('Live (${_liveSessions.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 8),
                  Text('Upcoming (${_upcomingSessions.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSessionsList(_liveSessions, isLive: true),
          _buildSessionsList(_upcomingSessions, isLive: false),
        ],
      ),
    );
  }

  Widget _buildSessionsList(
    List<LearningSession> sessions, {
    required bool isLive,
  }) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLive ? Icons.live_tv : Icons.schedule,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isLive ? 'No live sessions right now' : 'No upcoming sessions',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isLive
                  ? 'Check back later for live learning sessions'
                  : 'New sessions are added regularly',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        Fluttertoast.showToast(msg: "Sessions refreshed!");
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return _buildSessionCard(sessions[index]);
        },
      ),
    );
  }

  Widget _buildSessionCard(LearningSession session) {
    final bool canJoin = session.participants < session.maxParticipants;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border:
            session.isLive
                ? Border.all(color: Colors.red.withOpacity(0.3), width: 2)
                : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with live indicator and topic
            Row(
              children: [
                if (session.isLive) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 8),
                        SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    session.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002C83),
                    ),
                  ),
                ),
                _buildTopicChip(session.topic),
              ],
            ),

            const SizedBox(height: 12),

            // Instructor and level info
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  session.instructor,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.bar_chart, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  session.level,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Time and participants
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatSessionTime(session),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                const Icon(Icons.group, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${session.participants}/${session.maxParticipants}',
                  style: TextStyle(
                    fontSize: 14,
                    color: canJoin ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Capacity progress bar
            LinearProgressIndicator(
              value: session.participants / session.maxParticipants,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                canJoin ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 16),

            // Join/Register button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_isJoining || !canJoin)
                        ? null
                        : () => _joinSession(session),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      session.isLive ? Colors.red : const Color(0xFF002C83),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isJoining
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              session.isLive ? Icons.videocam : Icons.schedule,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              canJoin
                                  ? (session.isLive
                                      ? 'Join Session'
                                      : 'Register')
                                  : 'Session Full',
                              style: const TextStyle(
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

  Widget _buildTopicChip(String topic) {
    Color chipColor;
    switch (topic.toLowerCase()) {
      case 'grammar':
        chipColor = Colors.blue;
        break;
      case 'vocabulary':
        chipColor = Colors.green;
        break;
      case 'conversation':
        chipColor = Colors.orange;
        break;
      case 'business':
        chipColor = Colors.purple;
        break;
      case 'pronunciation':
        chipColor = Colors.teal;
        break;
      case 'test prep':
        chipColor = Colors.indigo;
        break;
      case 'writing':
        chipColor = Colors.pink;
        break;
      case 'culture':
        chipColor = Colors.amber;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        topic,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatSessionTime(LearningSession session) {
    if (session.isLive) {
      final remaining = session.endTime.difference(DateTime.now());
      final minutes = remaining.inMinutes;
      return 'Ends in ${minutes}m';
    } else {
      final start = session.startTime;
      final now = DateTime.now();
      final isToday =
          start.day == now.day &&
          start.month == now.month &&
          start.year == now.year;
      final isTomorrow =
          start.day == now.add(const Duration(days: 1)).day &&
          start.month == now.add(const Duration(days: 1)).month &&
          start.year == now.add(const Duration(days: 1)).year;

      String dateStr;
      if (isToday) {
        dateStr = 'Today';
      } else if (isTomorrow) {
        dateStr = 'Tomorrow';
      } else {
        dateStr = '${start.day}/${start.month}';
      }

      return '$dateStr at ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    }
  }
}

// Simple Learning Session model
class LearningSession {
  final String id;
  final String title;
  final String instructor;
  int participants; // Made mutable for demo purposes
  final int maxParticipants;
  final DateTime startTime;
  final DateTime endTime;
  final String level;
  final String topic;
  final bool isLive;

  LearningSession({
    required this.id,
    required this.title,
    required this.instructor,
    required this.participants,
    required this.maxParticipants,
    required this.startTime,
    required this.endTime,
    required this.level,
    required this.topic,
    required this.isLive,
  });
}
