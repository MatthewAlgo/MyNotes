import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/loginview.dart';
import '../views/notesview.dart';

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

void showTrashPopup(BuildContext context, User? usercredential, String title) {
  final alert = AlertDialog(
    title: const Text('Warning'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
            "Are you  sure you want to permanently delete the note from the database?")
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('No'),
      ),
      TextButton(
        onPressed: () async {
          CollectionReference notes = FirebaseFirestore.instance.collection('users');
          // Show an information dialog
          await notes
              .doc(usercredential?.email.toString())
              .collection('trash')
              .doc(title)
              .delete()
              // ignore: avoid_print
              .then((value) => print('Deleted'))
              .catchError((error) => print(error));
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop(); // Close the popup
          // Create a snackbar to inform the user that the email is sent
          // ignore: deprecated_member_use, use_build_context_synchronously
        },
        child: const Text('Yes'),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showLogoutDialog(BuildContext context) {
  final alert = AlertDialog(
    title: const Text('Warning'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[Text("Are you sure you want to logout?")],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('No'),
      ),
      TextButton(
        onPressed: () async {
          signOut();
          Navigator.of(context).pop(); // Close the popup
          
          Navigator.pushReplacementNamed(context, '/login/');
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginView()));
          
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => const LoginView()));
        },
        child: const Text('Yes'),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
