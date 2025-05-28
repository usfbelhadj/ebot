import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

// Message model class
class Message {
  final bool isUser;
  final String? text;

  Message({required this.isUser, this.text});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Message> messages = [];
  bool isTyping = false;

  void sendMessage() async {
    String text = controller.text;
    String apiKey = 'AIzaSyBQbi_twDvMlCVLFf28kxxxrpGmmPgGSn4';
    controller.clear();

    try {
      if (text.isNotEmpty) {
        setState(() {
          messages.insert(0, Message(isUser: true, text: text));
          isTyping = true;
        });

        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

        var response = await http.post(
          Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "contents": [
              {
                "role": "user",
                "parts": [
                  {
                    "text":
                        "You are an English learning assistant. Only answer questions related to learning English. Politely refuse anything else.",
                  },
                ],
              },
              {
                "role": "user",
                "parts": [
                  {"text": text},
                ],
              },
            ],
          }),
        );

        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          String reply = json["candidates"][0]["content"]["parts"][0]["text"];

          setState(() {
            isTyping = false;
            messages.insert(0, Message(isUser: false, text: reply.trimRight()));
          });

          scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          // Handle error
          setState(() {
            isTyping = false;
            messages.insert(
              0,
              Message(
                isUser: false,
                text:
                    "Sorry, I couldn't process your request. Please try again.",
              ),
            );
          });
        }
      }
    } catch (e) {
      // Handle exception
      setState(() {
        isTyping = false;
        messages.insert(
          0,
          Message(
            isUser: false,
            text:
                "An error occurred. Please check your connection and try again.",
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Some error occurred, please try again!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your English Assistant 🤖',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002C83),
                  ),
                ),
              ),
            ),

            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message.isUser;
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFF002C83) : Colors.white,
                        border: Border.all(color: const Color(0xFF002C83)),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft:
                              isUser ? const Radius.circular(20) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : const Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isUser)
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.smart_toy,
                                size: 16,
                                color: Color(0xFF002C83),
                              ),
                            ),
                          Flexible(
                            child: MarkdownBody(
                              data: message.text!,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  fontSize: 16,
                                  color:
                                      isUser
                                          ? Colors.white
                                          : const Color(0xFF002C83),
                                ),
                                strong: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isUser
                                          ? Colors.white
                                          : const Color(0xFF002C83),
                                ),
                                em: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color:
                                      isUser
                                          ? Colors.white
                                          : const Color(0xFF002C83),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Typing indicator
            if (isTyping)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(color: Color(0xFF002C83)),
              ),

            // Message input field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4EAFB),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Type your question...',
                          border: InputBorder.none,
                          icon: Icon(Icons.person_outline),
                        ),
                        onSubmitted: (value) => sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: sendMessage,
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF002C83),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // No bottom navigation bar here since it's handled by HomeScreen
    );
  }
}
