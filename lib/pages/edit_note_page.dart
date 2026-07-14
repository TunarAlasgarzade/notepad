import 'package:hive/hive.dart';
import 'package:notepad/models/note_model.dart';
import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({
    super.key,
    required this.note,
    required this.index,
  });

  final NoteModel note;
  final int index;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    noteController.text = widget.note.note;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: titleController,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2
                    )
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2
                    ),
                  ),
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: Colors.grey
                  )
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: noteController,
                cursorColor: Colors.green,
                minLines: 8,
                maxLines: 10,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2
                    )
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2
                    ),
                  ),
                  hintText: "Note",
                  hintStyle: TextStyle(
                    color: Colors.grey
                  )
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text("Cancel", style: TextStyle(color: Colors.white),)
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
                      final note = NoteModel(
                        title: titleController.text, 
                        note:  noteController.text,
                      );
                    final box = Hive.box("notes");
                    box.putAt(widget.index, note.toMap());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Note Edited!"))
                    );
                    Navigator.pop(context, note);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in all fields"))
                      );
                    }
                  }, 
                  child: Text("Save", style: TextStyle(color: Colors.white),)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}