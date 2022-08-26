import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/crypto/cryptofuncs.dart';
import 'package:mynotes/custom/backgroundvideo.dart';
import 'package:mynotes/views/loginview.dart';
import 'package:pointycastle/pointycastle.dart';

import '../custom/textfields.dart';
import '../firebase_options.dart';
import '../net/firebase.dart';

import 'package:flutter/src/widgets/basic.dart' as BasicPkg;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
            'Register - MyNotes',
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
            BasicPkg.Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BasicPkg.Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: BasicPkg.Padding(
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
                      BasicPkg.Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: BasicPkg.Padding(
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
                      ),
                      BasicPkg.Padding(
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
                                  // Try to create user and add it to the database
                                  final userCredential = await FirebaseAuth
                                      .instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  print(userCredential);

                                  // TODO: Generate private / public key pair to encrypt user data

                                  final addToDatabase = await AddUserToDatabase(
                                      userCredential.user?.email,
                                      userCredential.user?.uid,
                                      userCredential.user?.emailVerified);
                                  final listUsers = await getData();

                                
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginView()));
                                  // Return a loginview instance if everything was succesful so that the user can log in with their credentials
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    showMessage(
                                        context, 'The password is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    showMessage(context,
                                        'The email is already in use with another account.');
                                  } else if (e.code == 'invalid-email') {
                                    showMessage(context,
                                        'The email address is malformed.');
                                  } else if (e.code ==
                                      'operation-not-allowed') {
                                    showMessage(context,
                                        'Password sign-in is disabled for this project.');
                                  } else if (e.code == 'user-disabled') {
                                    showMessage(context,
                                        'The user account has been disabled.');
                                  } else if (e.code == 'user-not-found') {
                                    showMessage(context,
                                        'There is no user record corresponding to this identifier. The user may have been deleted.');
                                  } else if (e.code == 'wrong-password') {
                                    showMessage(context,
                                        'The password is invalid or the user does not have a password.');
                                  } else {
                                    showMessage(
                                        context, 'Error at registration');
                                  }
                                }
                              },
                              child: const Text('Register')),
                        ),
                      ),
                      BasicPkg.Padding(
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
                                  '/login/', (route) => false);
                            },
                            child: const Text('Already have an account? Login'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

// Create a function that shows a scaffold with a message
void showMessage(BuildContext context, String message) {
  // ignore: deprecated_member_use
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void generateKeyPair() async {
  // Generates key pair
  final keypair =
      await CryptoLocal.getRSAKeyPair(CryptoLocal.exampleSecureRandom());
  final myPublic = keypair.publicKey as RSAPublicKey;
  final myPrivate = keypair.privateKey as RSAPrivateKey;

  // We need to make use of those keys
}
