import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mynotes/views/authenticationview.dart';
import 'package:mynotes/views/addnewnote.dart';
import 'package:mynotes/custom/backgroundvideo.dart';
import 'package:mynotes/views/editnote.dart';
import 'package:mynotes/views/loadingview.dart';

import 'package:mynotes/views/loginview.dart';
import 'package:mynotes/views/notesview.dart';
import 'package:mynotes/views/registerview.dart';
import 'package:mynotes/views/settingsview.dart';
import 'package:mynotes/views/trashview.dart';
import 'package:mynotes/views/verifyemailview.dart';
import 'package:mynotes/views/viewnote.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/verifyemail/': (context) => const VerifyEmailView(),
      '/notes/': (context) => const NotesView(),
      '/addnote/': (context) => const AddNewNote(),
      '/viewnote/': (context) => const ViewNote(),
      '/editnote/': (context) => const EditNote(),
      '/trash/': (context) => const TrashView(),
      '/settings/': (context) => const SettingsView(),
      '/auth/': (context) => const AuthView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static late bool is_auth_enabled = false;
  static late bool comes_from_auth_view = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FutureBuilderFunctionCall(),
        builder: (context, snapshot) {
          if (is_auth_enabled && !comes_from_auth_view) {
            return const AuthView();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user?.emailVerified == true) {
                print('You are a verified user');

                // Display app contents here
                return const NotesView();
              } else {
                if (user != null) {
                  print('You are not a verified user');

                  // Display verification page here
                  return const VerifyEmailView();
                } else {
                  return const LoginView();
                }
              }
            // return const LoginView();
            default:
              return const LoadingView();
          }
        });
  }
}

Future<FirebaseApp> FutureBuilderFunctionCall() async {
  String localAuthState = await SettingsView.getAuthState() ?? "";
  if (localAuthState != "") {
    if (localAuthState == 'true') {
      HomePage.is_auth_enabled = true;
    } else if (localAuthState == 'false') {
      HomePage.is_auth_enabled = false;
    }
  }
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
