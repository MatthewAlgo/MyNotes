import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../net/firebase.dart';

// ignore: must_be_immutable
class AddNewNote extends StatefulWidget {
  const AddNewNote({Key? key}) : super(key: key);

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

// Create a class that holds a note
class Note {
  String title;
  String content;
  Note({required this.title, required this.content});
}

class _AddNewNoteState extends State<AddNewNote> {
  late final TextEditingController _title;
  late final TextEditingController _content;

  @override
  void initState() {
    _title = TextEditingController();
    _content = TextEditingController();
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
      appBar: AppBar(
        title: Text('Add a New Note', style: GoogleFonts.sacramento(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Note title'),
              ],
            ),
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
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Note content'),
              ],
            ),
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
            Column(
              children: [
                TextButton(
                    onPressed: () async {
                      // Create a new note
                      final note = Note(
                        title: _title.text,
                        content: _content.text,
                      );
                      
                      // Get the email of the firebase user
                      final user = FirebaseAuth.instance.currentUser;
                      addNote(user!.email.toString(), note.title, note.content, context);
                      
                      // Navigate back to the list of notes
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Add Note')),
                TextButton(
                    onPressed: () {
                      // Navigate to the list of notes
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Cancel')),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
