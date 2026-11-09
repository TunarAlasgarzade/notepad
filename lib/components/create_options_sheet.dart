import 'package:flutter/material.dart';
import 'package:notepad/pages/add_note_page.dart';
import 'package:notepad/pages/add_task_page.dart';

class CreateOptionsSheet extends StatelessWidget {
  const CreateOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        Container(
          width: 33.5,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.note_add_outlined),
          title: Text("Add Note"),
          subtitle: Text("Create a new note"),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNotePage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.add_task),
          title: Text("Add Task"),
          subtitle: Text("Create a new checklist"),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTaskPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}