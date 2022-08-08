import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewNote extends StatefulWidget {
  final String title;
  final String content;
  const ViewNote({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Note'),
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
            Text(widget.title),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Note content'),
              ],
            ),
            Text(widget.content),
          ],
        ),
      ),
      ),
    );
  }
}
