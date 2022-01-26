import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.isThisUser,
    required this.chatItem,
  }) : super(key: key);

  final bool isThisUser;
  final ChatMessageModel chatItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: isThisUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isThisUser ? Colors.blue : Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isThisUser ? 20 : 0),
              topRight: const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
              bottomRight: Radius.circular(isThisUser ? 0 : 20),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isThisUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                isThisUser ? "Me" : "By ${chatItem.username}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                chatItem.message,
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.white),
              ),
              // Text(
              //   chatItem.timestamp.toDate().toLocal().toString(),
              //   textAlign: TextAlign.right,
              //   style: TextStyle(color: Colors.grey[350]),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
