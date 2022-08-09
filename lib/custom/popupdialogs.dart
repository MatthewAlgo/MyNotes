import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget _buildPopupDialog(BuildContext context, UserCredential usercredential) {
  return AlertDialog(
    title: const Text('Login Successful'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
            "You need to verify your email address! An email will be sent to you after you press ok")
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
      TextButton(
        onPressed: () async {
          await usercredential.user?.sendEmailVerification();
          // Create a snackbar to inform the user that the email is sent
          // ignore: deprecated_member_use, use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email sent"),
            ),
          );
        },
        child: const Text('Send Email'),
      ),
    ],
  );
}