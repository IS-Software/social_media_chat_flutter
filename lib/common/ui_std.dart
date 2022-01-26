import 'package:flutter/material.dart';

class UIK {
  static const kAuthTextFieldDecoration = InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    labelText: "value",
  );

  static const Widget loading = Center(
    child: CircularProgressIndicator(),
  );

  static const Widget errorText = Text(
    "Oops, something went wrong",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.orange,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
  );

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[900],
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
