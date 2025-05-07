// import 'package:flutter/material.dart';
// import 'chat_bot_screen .dart';

// class GrammarQuizScreen extends StatefulWidget {
//   const GrammarQuizScreen({super.key});

//   @override
//   State<GrammarQuizScreen> createState() => _GrammarQuizScreenState();
// }

// class _GrammarQuizScreenState extends State<GrammarQuizScreen> {
//   String? selectedAnswer;

//   final List<String> options = ['am going', 'go', 'goes', 'will go'];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFDFDFD),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF002C83)),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Grammar Quiz',
//           style: TextStyle(
//             color: Color(0xFF002C83),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.06),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: screenHeight * 0.02),
//               const Text(
//                 'Complete the sentence\nwith the correct verb form',
//                 style: TextStyle(
//                   color: Color(0xFF002C83),
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: screenHeight * 0.05),
//               const Text(
//                 'Tomorrow I ____ to the beach.',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: screenHeight * 0.05),
//               // Options grid
//               Wrap(
//                 spacing: screenWidth * 0.05,
//                 runSpacing: screenHeight * 0.02,
//                 alignment: WrapAlignment.center,
//                 children: options.map((option) {
//                   final isSelected = selectedAnswer == option;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedAnswer = option;
//                       });
//                     },
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       width: screenWidth * 0.4,
//                       padding: EdgeInsets.symmetric(
//                         vertical: screenHeight * 0.02,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? const Color(0xFF002C83)
//                             : Colors.white,
//                         border: Border.all(
//                           color: isSelected
//                               ? const Color(0xFF002C83)
//                               : Colors.redAccent,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: isSelected
//                             ? [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ]
//                             : [],
//                       ),
//                       child: Center(
//                         child: Text(
//                           option,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: isSelected ? Colors.white : Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),

//               SizedBox(height: screenHeight * 0.05),

//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF002C83),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 14,
//                   ),
//                 ),
//                 onPressed: () {
//                   // Show result first
//                   if (selectedAnswer != null) {
//                     final bool isCorrect = selectedAnswer == 'am going';
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           isCorrect 
//                               ? 'Correct! "am going" is the correct answer.' 
//                               : 'Incorrect. The correct answer is "am going".',
//                         ),
//                         backgroundColor: isCorrect ? Colors.green : Colors.red,
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
                    
//                     // Navigate to chat bot after showing result
//                     Future.delayed(const Duration(seconds: 2), () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ChatScreen(),
//                         ),
//                       );
//                     });
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please select an answer'),
//                       ),
//                     );
//                   }
//                 },
//                 child: const Text(
//                   'Submit',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }