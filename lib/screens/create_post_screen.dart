import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/common/ui_std.dart';
import 'package:social_media_chat_flutter/services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  static const String route = "/post_screen/create_post_screen";

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  late final File imageFile;

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    Post.sendPost(description: _description, image: imageFile);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    imageFile = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
            // description
            TextFormField(
              decoration: UIK.kAuthTextFieldDecoration
                  .copyWith(labelText: "Description"),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => _submit(context),
              onSaved: (newValue) => _description = newValue!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please provide description";
                }

                return null;
              },
            ),
            ElevatedButton(
                onPressed: () => _submit(context), child: const Text("Send")),
          ],
        ),
      ),
    );
  }
}
