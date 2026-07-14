import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notepad/models/note_model.dart';
import 'package:notepad/pages/add_note_page.dart';
import 'package:notepad/pages/note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> notes = [];
  @override
  void initState() {
    super.initState();
    final box = Hive.box("notes");
    for (var item in box.values) {
      final note = NoteModel.fromMap(
        Map<String, dynamic>.from(item),
      );
      notes.add(note);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotePage(),
            ),
          );
          if (result is NoteModel) {
            final box = Hive.box("notes");
            box.add(result.toMap());
            setState(() {
              notes.add(result);
            });
          }
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              notes[index].title
            ),
            subtitle: Text(
              notes[index].note,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red,), 
              onPressed: () async {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: Text("Delete this note?"),
                    content: Text("This action cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () {Navigator.pop(context);}, 
                        child: Text("Cancel", style: TextStyle(color: Colors.green))
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final box = Hive.box("notes");
                          await box.deleteAt(index);
                          setState(() {
                            notes.removeAt(index);
                          });
                        }, 
                        child: Text("Delete", style: TextStyle(color: Colors.green),)
                      )
                    ],
                  ),
                );
              },),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotePage(
                    note: notes[index],
                    index: index,
                  ),
                ),
              );
              if (result is NoteModel) {
                setState(() {
                  notes[index] = result;
                });
              }
            },
          );
        }
      ),
    );
  }
}