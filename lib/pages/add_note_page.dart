import 'package:notepad/components/my_textfield.dart';
import 'package:notepad/models/note_model.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyTextfield(
                controller: titleController, 
                hintText: "Title"
              )
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyTextfield(
                controller: noteController, 
                hintText: "Note",
                minLines: 8,
                maxLines: 10,
              )
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Note Saved!"))
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