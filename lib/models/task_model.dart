import 'package:notepad/models/todo_model.dart';

class TaskModel {
  final String title;
  final List<TodoModel> todos;

  TaskModel({
    required this.title,
    required this.todos,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "todos": todos.map((todo) => todo.toMap()).toList(),
    };
  }

  TaskModel.fromMap(Map<String, dynamic> map) 
    : title = map["title"] ?? "",
      todos = (map["todos"] as List? ?? [])
        .map((todo) => TodoModel.fromMap(Map<String, dynamic>.from(todo)))
        .toList();
}