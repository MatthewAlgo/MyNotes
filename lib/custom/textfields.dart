import 'package:flutter/material.dart';

Widget buildCustomTextField(BuildContext context, String label,
    TextEditingController controller, String hint, bool enableSuggestions, bool autocorrect, TextInputType kT, bool obscureText) {
  return TextField(
    textAlign: TextAlign.center,
    controller: controller,
    keyboardType: kT,
    enableSuggestions: enableSuggestions,
    autocorrect: autocorrect,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(16),
      fillColor: Theme.of(context).primaryColor,
    ),
  );
}
