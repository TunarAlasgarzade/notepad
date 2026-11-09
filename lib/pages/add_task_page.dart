import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notepad/components/my_button.dart';
import 'package:notepad/components/my_textfield.dart';
import 'package:notepad/models/task_model.dart';
import 'package:notepad/models/todo_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final List<TextEditingController> _todoControllers = [
    TextEditingController()
  ];

  void _addTodo() {
    setState(() {
      _todoControllers.add(TextEditingController());
    });
  }

  void _deleteTodo(int index) {
    if (_todoControllers.length > 1) {
      final controller = _todoControllers[index];
      setState(() {
        _todoControllers.removeAt(index);
      });
      controller.dispose();
    }
  }

  void _saveTask() async {
    if (_titleController.text.trim().isEmpty) return;
    final todos = _todoControllers
        .where((controller) => controller.text.trim().isNotEmpty)
        .map((controller) => TodoModel(
          title: controller.text, 
          isComplete: false
        )).toList();
    if (todos.isEmpty) return;
     await Hive.box("tasks").add(
      TaskModel(
        title: _titleController.text, 
        todos: todos
      ).toMap(),
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _todoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MyTextfield(
                  controller: _titleController, 
                  hintText: "Title"
                ),
              ),
              SizedBox(height: 12),
              ...List.generate(
                _todoControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _todoControllers[index],
                            decoration: InputDecoration(
                              hintText: "Todo",
                              hintStyle: TextStyle(color: Colors.grey)
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _deleteTodo(index), 
                          icon: Icon(Icons.close)
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              MyButton(
                onPressed: _addTodo, 
                text: "Add Todo"
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    onPressed: () => Navigator.pop(context), 
                    text: "Cancel"
                  ),
                  MyButton(
                    onPressed: _saveTask,
                    text: "Save"
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}