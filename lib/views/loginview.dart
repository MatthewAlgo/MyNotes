import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/net/firebase.dart';
import 'package:mynotes/views/registerview.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
            ),
            Column(
              children: [
                TextButton(
                    onPressed: () async {
                      // Get user name and password
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        final usercredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        print(usercredential.user);
                        // We update the database so that the user is logged in
                        updateUser(usercredential.user?.email, usercredential.user?.uid, usercredential.user?.emailVerified);
          
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                        
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          // Show a snackbar with the error message
                          // ignore: deprecated_member_use
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("User not found"),
                            ),
                          );
                          
                        } else if (e.code == 'wrong-password') {
                          // Show a snackbar with the error message
                          // ignore: deprecated_member_use
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Wrong password, try again"),
                            ),
                          );
                        } else {
                          // Show a snackbar with the error message
                          // ignore: deprecated_member_use
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error signing in"),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Login')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/register/', (route) => false);
                    },
                    child: const Text("Not registered yet? Register here")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
