// Edit note view
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplenotes/custom/Textfields.dart';
import 'package:simplenotes/views/viewnote.dart';

import '../net/Firebase.dart';

// ignore: must_be_immutable
class EditNote extends StatefulWidget {
  const EditNote({Key? key}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

// Create a class that holds a note
class Note {
  String title;
  String content;
  Note({required this.title, required this.content});
}

class _EditNoteState extends State<EditNote> {
  late final TextEditingController _title;
  late final TextEditingController _content;

  @override
  void initState() {
    _title = TextEditingController(text: NoteToBeShown.title);
    _content = TextEditingController(text: NoteToBeShown.content);
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 207, 213),
      appBar: AppBar(
          title: Text(
        'Edit Note',
        style: GoogleFonts.sacramento(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Create an input field for the title
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _title,
                  decoration: const InputDecoration(
                    hintText: 'Enter the title here',
                  ),
                  style: GoogleFonts.sacramento(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )),

            // Create an input field for the content
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _content,
                  decoration: const InputDecoration(
                    hintText: 'Enter the content here',
                  ),
                  style: GoogleFonts.sacramento(
                    fontSize: 25,
                  ),
                )),

            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;

                // Deletes the past document and saves the new one
                FirebaseFirestore.instance
                    .doc("users/${user!.email.toString()}")
                    .collection("notes")
                    .doc(NoteToBeShown.title)
                    .delete();

                // Save the note
                final note = Note(
                  title: _title.text,
                  content: _content.text,
                );
                addNote(
                    user.email.toString(), note.title, note.content, context);

                // Save the modified note to the database
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )),
    );
  }
}
