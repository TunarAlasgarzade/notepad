import 'package:notepad/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:notepad/pages/edit_note_page.dart';

class NotePage extends StatefulWidget {
  final NoteModel note;
  final int index;
  const NotePage({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title, style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => EditNotePage(
                note: widget.note,
                index: widget.index,
              ),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.edit, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SelectableText(widget.note.note),
        ),
      ),
    );
  }
}