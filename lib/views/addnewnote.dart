import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        title: const Text('Add a New Note'),
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
            TextField(
              controller: _title,
              
              decoration: const InputDecoration(
                hintText: 'Enter the title here',
              ),
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Note content'),
              ],
            ),
            // Create an input field for the content
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _content,
              decoration: const InputDecoration(
                hintText: 'Enter the content here',
              ),
            ),
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
                      addNote(user!.email.toString(), note.title, note.content);
                      
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
