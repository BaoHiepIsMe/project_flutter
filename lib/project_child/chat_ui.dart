import 'package:flutter/material.dart';

class ChatUI extends StatelessWidget {
  const ChatUI({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {'isMe': false, 'text': 'Hello! How are you?'},
      {'isMe': true, 'text': 'I’m great, thanks!'},
      {'isMe': false, 'text': 'Ready to start the project?'},
      {'isMe': true, 'text': 'Absolutely! Let’s go 🚀'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Chat UI Clone")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isMe = msg['isMe'] as bool;
          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue[200] : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(msg['text'] as String),
            ),
          );
        },
      ),
    );
  }
}
