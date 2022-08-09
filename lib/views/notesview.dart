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
import 'package:mynotes/views/viewnote.dart';

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
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
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
                        WidgetsBinding?.instance.addPostFrameCallback((_) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Icon(Icons.inbox),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    // Logout Popup Dialog
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        _signOut();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginView(),
                                          ),
                                        );
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              });
                        });
                      }
                    });
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
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
                          title: Text(document['title'],
                            textAlign: TextAlign.center,
                              style: GoogleFonts.sacramento(
                                fontSize: 30,
                              )),
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
                                onPressed: () => // Delete the note
                                    FirebaseFirestore.instance
                                        .doc("users/${user!.email.toString()}")
                                        .collection("notes")
                                        .doc(document['title'])
                                        .delete(),
                              ), // icon-2
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
      ),

      // Drawer for the app
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                accountName: Text(
                  user?.displayName ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPictureSize: const Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 151, 0, 239),
                  child: Text(
                    user?.displayName?[0] ?? '?',
                    style: const TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
              ),
              title: const Text('Trash'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // Bottom drawer
      bottomNavigationBar: BottomBarWithSheet(
        controller: _bottomBarController,
        bottomBarTheme: const BottomBarTheme(
          decoration: BoxDecoration(color: Color.fromARGB(255, 230, 17, 17)),
          itemIconColor: Colors.grey,
        ),
        items: const [
          BottomBarWithSheetItem(icon: Icons.people),
          BottomBarWithSheetItem(icon: Icons.favorite),
        ],
      ),
    );
  }
}

User? _signOut() {
  FirebaseAuth.instance.signOut();
  final user = FirebaseAuth.instance.currentUser;
  return user;
}
