import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/net/firebase.dart';
import 'package:mynotes/custom/backgroundvideo.dart';
import 'package:mynotes/views/registerview.dart';
import 'package:video_player/video_player.dart';

import '../firebase_options.dart';
import '../custom/textfields.dart';

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
        title: Text(
          'Login - MyNotes',
          style: GoogleFonts.sacramento(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          VideoWidget(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildCustomTextField(
                                context,
                                'Email',
                                _email,
                                'Enter your email here',
                                false,
                                false,
                                TextInputType.emailAddress,
                                false),
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildCustomTextField(
                              context,
                              'Password',
                              _password,
                              'Enter your password here',
                              false,
                              false,
                              TextInputType.visiblePassword,
                              true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton(
                                    onPressed: () async {
                                      // Get user name and password
                                      final email = _email.text;
                                      final password = _password.text;
                                      try {
                                        final usercredential = await FirebaseAuth
                                            .instance
                                            .signInWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );
                                        // We update the database so that the user is logged in
                                        updateUser(
                                            usercredential.user?.email,
                                            usercredential.user?.uid,
                                            usercredential.user?.emailVerified);
                            
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const HomePage(),
                                          ),
                                        );
                                        // TODO: A more ellegant sollution 
                                        // Navigator.of(context).pushReplacement(
                                        //     MaterialPageRoute(builder: (context) => const HomePage()));
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
                                              content:
                                                  Text("Wrong password, try again"),
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
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                          '/register/', (route) => false);
                                    },
                                    child: const Text(
                                        "Not registered yet? Register here")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
