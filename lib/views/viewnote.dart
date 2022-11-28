import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.
class NoteToBeShown {
  static late String title;
  static late String content;
}

class ViewNote extends StatefulWidget {
  const ViewNote({Key? key}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as NoteToBeShown;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 207, 213),
      appBar: AppBar(
        title: const Text('View Note'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  NoteToBeShown.title,
                  style: GoogleFonts.sacramento(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  NoteToBeShown.content,
                  style: GoogleFonts.sacramento(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
