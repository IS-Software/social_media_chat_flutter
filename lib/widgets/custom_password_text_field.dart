import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/common/ui_std.dart';

class CustomPasswordTextField extends StatelessWidget {
  final FocusNode focusNode;
  final void Function(BuildContext context) onSubmit;

  String _value = "";
  String get value => _value;

  CustomPasswordTextField({
    Key? key,
    required this.focusNode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      obscureText: true,
      onSaved: (newValue) => _value = newValue!.trim(),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) => onSubmit(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please provide password";
        }

        if (value.length < 6) {
          return "Please provide longer password";
        }

        return null;
      },
      decoration:
          UIK.kAuthTextFieldDecoration.copyWith(labelText: "Enter password"),
    );
  }
}
