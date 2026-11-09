import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notepad/components/my_textfield.dart';
import 'package:notepad/models/task_model.dart';
import 'package:notepad/models/todo_model.dart';

class TaskPage extends StatefulWidget {
  final TaskModel task;
  final int taskIndex;
  const TaskPage({
    super.key,
    required this.task,
    required this.taskIndex,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _editTodoController = TextEditingController();
  final _editTaskController = TextEditingController();
  final _addTodoController = TextEditingController();
  late String _taskTitle;

  @override
  void initState() {
    super.initState();
    _taskTitle = widget.task.title;
  }

  @override
  void dispose() {
    _editTodoController.dispose();
    _editTaskController.dispose();
    _addTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_taskTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              _editTaskController.text = _taskTitle;
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  title: Text("Edit Task"),
                  content: MyTextfield(
                    controller: _editTaskController,
                    hintText: "Task"
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: Text("Cancel")
                    ),
                    FilledButton(
                      onPressed: () async {
                        if (_editTaskController.text.trim().isEmpty) return;
                        final updatedTask = TaskModel(
                          title: _editTaskController.text, 
                          todos: widget.task.todos,
                        );
                        await Hive.box("tasks").putAt(
                          widget.taskIndex,
                          updatedTask.toMap(),
                        );
                        if (!mounted) return;
                        setState(() {
                          _taskTitle = _editTaskController.text;
                        });
                        Navigator.pop(this.context);
                        _editTaskController.clear();
                      }, 
                      child: Text("Save", style: TextStyle(color: Colors.white))
                    ),
                  ],
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              );
            },
            icon: Icon(Icons.edit)
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: widget.task.todos.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: widget.task.todos[index].isComplete, 
                  checkColor: Colors.white,
                  onChanged: (value) async {
                    final todo = widget.task.todos[index];
                    final updatedTodo = TodoModel(
                      title: todo.title, 
                      isComplete: value ?? false,
                    );
                    setState(() {
                      widget.task.todos[index] = updatedTodo;
                    });
                    await Hive.box("tasks").putAt(
                      widget.taskIndex,
                      widget.task.toMap(),
                    );
                    if (!mounted) return;
                  },
                ),
                title: SelectableText(
                  widget.task.todos[index].title,
                   style: TextStyle(
                    decoration: widget.task.todos[index].isComplete
                    ? TextDecoration.lineThrough 
                    : null 
                  ),
                ),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == "delete") {
                      showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: Text("Delete Todo?"),
                          content: Text("Are you sure you want to delete this Todo?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), 
                              child: Text("Cancel")
                            ),
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  widget.task.todos.removeAt(index);
                                });
                                await Hive.box("tasks").putAt(
                                  widget.taskIndex,
                                  widget.task.toMap(),
                                );
                                if (!mounted) return;
                                Navigator.pop(this.context);
                              }, 
                              child: Text("Delete")
                            ),
                          ],
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                      );
                    }
                    if (value == "edit") {
                      _editTodoController.text = widget.task.todos[index].title;
                      showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: Text("Edit Todo"),
                          content: MyTextfield(
                            controller: _editTodoController,
                            hintText: "Todo"
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), 
                              child: Text("Cancel")
                            ),
                            FilledButton(
                              onPressed: () async {
                                if (_editTodoController.text.trim().isEmpty) return;
                                final todo = widget.task.todos[index];
                                final updatedTodo = TodoModel(
                                  title: _editTodoController.text, 
                                  isComplete: todo.isComplete,
                                );
                                setState(() {
                                  widget.task.todos[index] = updatedTodo;
                                });
                                await Hive.box("tasks").putAt(
                                  widget.taskIndex,
                                  widget.task.toMap(),
                                );
                                if (!mounted) return;
                                Navigator.pop(this.context);
                                _editTodoController.clear();
                              }, 
                              child: Text("Save", style: TextStyle(color: Colors.white))
                            ),
                          ],
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "edit",
                        child: Text(
                          "Edit Todo", style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface
                          )
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("Delete Todo", style: TextStyle(color: Colors.red)),
                      ),
                    ];
                  },
                  iconColor: Theme.of(context).colorScheme.onSurface,
                  color: Theme.of(context).colorScheme.secondary,
                )
              );
            },
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text("Add Todo"),
            content: MyTextfield(
              controller: _addTodoController,
              hintText: "Todo"
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("Cancel")
              ),
              FilledButton(
                onPressed: () async {
                  if (_addTodoController.text.trim().isEmpty) return;
                  final newTodo = TodoModel(
                    title: _addTodoController.text, 
                    isComplete: false
                  );
                  setState(() {
                    widget.task.todos.add(newTodo);
                  });
                  await Hive.box("tasks").putAt(
                    widget.taskIndex, 
                    widget.task.toMap()
                  );
                  _addTodoController.clear();
                  if (!mounted) return;
                  Navigator.pop(this.context);
                }, 
                child: Text("Save", style: TextStyle(color: Colors.white))
              ),
            ],
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}