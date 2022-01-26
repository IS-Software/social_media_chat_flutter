import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/common/ui_std.dart';
import 'package:social_media_chat_flutter/models/chat_message_model.dart';
import 'package:social_media_chat_flutter/services/post_service.dart';
import 'package:social_media_chat_flutter/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const String route = "/post_screen/chat_screen";

  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String _postId;
  String _message = "";

  @override
  Widget build(BuildContext context) {
    _postId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Post.streamChat(forId: _postId),
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.none) {
                return const Center(
                  child: UIK.errorText,
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return UIK.loading;
              }

              List<QueryDocumentSnapshot<Object?>> docs = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var chatItem =
                            ChatMessageModel.fromSnapshot(docs[index]);
                        bool isThisUser = Post.isThisUser(chatItem.userId);
                        return ChatBubble(
                          isThisUser: isThisUser,
                          chatItem: chatItem,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          onChanged: (value) => _message = value.trim(),
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter a message",
                          ),
                        )),
                        IconButton(
                          onPressed: () {
                            if (_message.isNotEmpty) {
                              Post.sendChatMessage(
                                  postId: _postId, message: _message);
                              setState(() {
                                _message = "";
                              });
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
