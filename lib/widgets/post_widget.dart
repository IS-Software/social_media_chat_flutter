import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/models/post_model.dart';
import 'package:social_media_chat_flutter/screens/chat_Screen.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ChatScreen.route,
          arguments: post.postId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(post.imageURL), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              post.username,
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              post.description,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
