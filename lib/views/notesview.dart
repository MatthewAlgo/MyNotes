// Main UI For people that are logged in

import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/views/addnewnote.dart';
import 'package:mynotes/views/loginview.dart';
import 'package:mynotes/views/settingsview.dart';
import 'package:mynotes/views/viewnote.dart';

import '../custom/drawers.dart';
import '../custom/popupdialogs.dart';
import '../net/firebase.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final BottomBarWithSheetController _bottomBarController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    _bottomBarController = BottomBarWithSheetController(initialIndex: 0);
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 255, 0),
      appBar: AppBar(
        title: Text(
          'MyNotes',
          // Apply google fonts
          style: GoogleFonts.sacramento(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.pushNamed(context, '/addnote/');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String item) {
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              // Creates the rightmost hamburger menu
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                    onTap: () {
                      if (choice == 'Logout') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Show the popup dialog for logout
                          showLogoutDialog(context);
                        });
                      } else if (choice == 'Settings') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Show the popup dialog for logout
                          Navigator.pushNamed(context, '/settings/');
                        });
                      }
                    });
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        Column(
          children: [
            // Get all notes from firebase
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .doc("users/${user!.email.toString()}")
                  .collection("notes")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  // ignore: curly_braces_in_flow_control_structures
                  return // A spinner from flutter_spinkit
                      const Center(
                    child: SpinKitThreeInOut(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  );
                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          tileColor: Colors.green,
                          title: Text(document['title'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sacramento(
                                  fontSize: 30,
                                  textStyle:
                                      const TextStyle(color: Colors.white))),
                          onTap: () {
                            NoteToBeShown.content = document[
                                'content']; // Static variable inside ViewNote
                            NoteToBeShown.title = document['title'];
                            Navigator.pushNamed(context, '/viewnote/');
                          },
                          // subtitle: Text(document['content'],textAlign: TextAlign.center,
                          //     style: GoogleFonts.sacramento(
                          //       fontSize: 20,
                          //     )),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <IconButton>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Show the addnewnote page with arguments
                                  NoteToBeShown.title = document['title'];
                                  NoteToBeShown.content = document[
                                      'content']; // Static variable inside ViewNote
                                  Navigator.pushNamed(context, '/editnote/');
                                },
                              ),

                              // Delete the note (from the database)
                              // TODO: Move the note to the trash! We need to create a trash collection
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    // Delete the note
                                    moveNoteToTrash(
                                        user.email.toString(),
                                        document["title"],
                                        document["content"],
                                        context);
                                  }), // icon-2
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            // End of stream builder
          ],
        ),
      ]),

      // Drawer for the app
      drawer: getMainDrawer(context, user),

      // Bottom drawer
      // bottomNavigationBar: BottomBarWithSheet(
      //   controller: _bottomBarController,
      //   bottomBarTheme: const BottomBarTheme(
      //     decoration: BoxDecoration(color: Color.fromARGB(255, 230, 17, 17)),
      //     itemIconColor: Colors.grey,
      //   ),
      //   items: const [
      //     BottomBarWithSheetItem(icon: Icons.people),
      //     BottomBarWithSheetItem(icon: Icons.favorite),
      //   ],
      // ),
    );
  }
}

Future<User?> signOut() async {
  await FirebaseAuth.instance.signOut();
  final user = await FirebaseAuth.instance.currentUser;
  return user;
}
