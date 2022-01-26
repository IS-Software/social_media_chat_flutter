import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_chat_flutter/bloc/auth_cubit/auth_cubit.dart';
import 'package:social_media_chat_flutter/common/ui_std.dart';
import 'package:social_media_chat_flutter/models/post_model.dart';
import 'package:social_media_chat_flutter/screens/create_post_screen.dart';
import 'package:social_media_chat_flutter/services/image_service.dart';
import 'package:social_media_chat_flutter/services/post_service.dart';
import 'package:social_media_chat_flutter/widgets/post_widget.dart';

class PostScreen extends StatefulWidget {
  static const String route = "/post_screen";

  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // add post
          IconButton(
              onPressed: () async {
                final imageFile =
                    await ImageService.getImage(from: ImageSource.camera);

                if (imageFile != null) {
                  Navigator.pushNamed(context, CreatePostScreen.route,
                      arguments: imageFile);
                } else {
                  UIK.showError(context, "No image");
                }
              },
              icon: const Icon(
                Icons.add_a_photo,
              )),
          // back to SignInScreen
          IconButton(
              onPressed: () {
                context.read<AuthCubit>().signOut(context: context);
              },
              icon: const Icon(
                Icons.logout,
              )),
        ],
      ),
      body: StreamBuilder(
        stream: Post.streamPosts,
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

          //else showing posts
          var docs = (snapshot as AsyncSnapshot<QuerySnapshot>).data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final post = PostModel.fromSnapshot(doc);
              return PostWidget(post: post);
            },
          );
        },
      ),
    );
  }
}
