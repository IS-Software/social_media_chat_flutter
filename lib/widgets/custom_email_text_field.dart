import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/common/ui_std.dart';

class CustomEmailTextField extends StatelessWidget {
  final FocusNode nextNode;

  String _value = "";
  String get value => _value;

  CustomEmailTextField({Key? key, required this.nextNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      onSaved: (newValue) => _value = newValue!.trim(),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please provide email";
        }

        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);

        if (!emailValid) {
          return "Enter valid email";
        }

        return null;
      },
      onFieldSubmitted: (value) =>
          FocusScope.of(context).requestFocus(nextNode),
      decoration:
          UIK.kAuthTextFieldDecoration.copyWith(labelText: "Enter e-mail"),
    );
  }
}
