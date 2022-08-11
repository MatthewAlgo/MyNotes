import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/net/firebase.dart';
import 'package:mynotes/views/viewnote.dart';

import '../custom/drawers.dart';
import '../custom/popupdialogs.dart';

class TrashView extends StatefulWidget {
  const TrashView({Key? key}) : super(key: key);

  @override
  State<TrashView> createState() => _TrashViewState();
}

class _TrashViewState extends State<TrashView> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Return a scaffold with the trash view
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trash',
          // Apply google fonts
          style: GoogleFonts.sacramento(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String item) {
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              // Creates the rightmost hamburger menu
              return {'Empty Trash'}.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                    onTap: () {
                      if (choice == 'Empty Trash') {
                        WidgetsBinding?.instance
                            .addPostFrameCallback((_) async {
                          // Show the popup dialog for logout
                          final user = FirebaseAuth.instance.currentUser;
                          CollectionReference notes =
                              FirebaseFirestore.instance.collection('users');

                          // Show an alert dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Empty Trash'),
                                content: const Text(
                                    'Are you sure you want to delete all notes?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Empty'),
                                    onPressed: () {
                                      
                                      // Delete all notes
                                      notes
                                          .doc(user?.email)
                                          .collection('trash')
                                          .get()
                                          .then((snapshot) {
                                        for (DocumentSnapshot note
                                            in snapshot.docs) {
                                          note.reference.delete();
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
                  .collection("trash")
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
                              tileColor: Color.fromARGB(255, 0, 255, 0),
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
                                icon: const Icon(Icons.restore_from_trash),
                                onPressed: () {
                                  // Show the addnewnote page with arguments
                                  NoteToBeShown.title = document['title'];
                                  NoteToBeShown.content = document[
                                      'content']; // Static variable inside ViewNote

                                  restoreNoteFromTrash(
                                      user.email.toString(),
                                      document['title'],
                                      document['content'],
                                      context);
                                },
                              ),

                              // Delete the note (from the database)
                              // TODO: Move the note to the trash! We need to create a trash collection
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => // Delete the note
                                    showTrashPopup(
                                        context, user, document['title']),
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
    );
  }
}
