import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notepad/components/create_options_sheet.dart';
import 'package:notepad/models/note_model.dart';
import 'package:notepad/models/task_model.dart';
import 'package:notepad/pages/note_page.dart';
import 'package:notepad/pages/task_page.dart';
import 'package:notepad/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            }, 
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode 
              ? Icons.nightlight_round 
              : Icons.wb_sunny, 
              color: Colors.white
            )
          )
        ],
      ),
      body: SafeArea(
        child: _buildItems()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context, 
            builder: (context) => CreateOptionsSheet(),
            backgroundColor: Theme.of(context).colorScheme.surface,
            useSafeArea: true
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildItems() {
    return ValueListenableBuilder(
      valueListenable: Hive.box("notes").listenable(), 
      builder: (context, notesBox, child) {
        return ValueListenableBuilder(
          valueListenable: Hive.box("tasks").listenable(), 
          builder: (context, tasksBox, child) {
            return ListView.builder(
              itemCount: notesBox.length + tasksBox.length,
              itemBuilder: (context, index) {
                if (index < notesBox.length) {
                  final note = NoteModel.fromMap(
                    Map<String, dynamic>.from(notesBox.getAt(index)),
                  );
                  return _buildNoteTile(note, context, notesBox, index);
                } else {
                  final taskIndex = index - notesBox.length;
                  final task = TaskModel.fromMap(
                    Map<String, dynamic>.from(tasksBox.getAt(taskIndex)),
                  );
                  final completedTodos = task.todos
                    .where((element) => element.isComplete)
                    .length;
                  return _buildTaskTile(task, completedTodos, context, tasksBox, taskIndex);
                }
              }
            );
          },
        );
      },
    );
  }

  Widget _buildTaskTile(
    TaskModel task, 
    int completedTodos, 
    BuildContext context, 
    Box<dynamic> tasksBox, 
    int taskIndex
  ) {
    return ListTile(
      leading: Icon(Icons.checklist),
      title: Text(task.title),
      subtitle: Text("$completedTodos of ${task.todos.length} completed"),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red,), 
        onPressed: () async {
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: Text("Delete this checklist?"),
              content: Text("This action cannot be undone."),
              backgroundColor: Theme.of(context).colorScheme.surface,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text(
                  "Cancel", style: TextStyle(
                    color: Theme.of(context).colorScheme.primary)
                  )
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await tasksBox.deleteAt(taskIndex);
                  }, 
                  child: Text(
                    "Delete", style: TextStyle(
                      color: Theme.of(context).colorScheme.primary
                    ),
                  )
                )
              ],
            ),
          );
        },
      ),
      onTap: () => Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => TaskPage(
            task: task,
            taskIndex: taskIndex,
          ),
        ),
      ),
      onLongPress: () => showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: SelectableText(task.title),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildNoteTile(
    NoteModel note, 
    BuildContext context, 
    Box<dynamic> notesBox, 
    int index
  ) {
    return ListTile(
      leading: Icon(Icons.note_alt_outlined),
      title: Text(
        note.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        note.note,
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text(
                  "Cancel", style: TextStyle(
                    color: Theme.of(context).colorScheme.primary)
                  )
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await notesBox.deleteAt(index);
                  }, 
                  child: Text(
                    "Delete", style: TextStyle(
                      color: Theme.of(context).colorScheme.primary
                    ),
                  )
                )
              ],
            ),
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => NotePage(
              note: note,
              index: index,
            ),
          ),
        );
      },
      onLongPress: () => showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: SelectableText(note.title),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}