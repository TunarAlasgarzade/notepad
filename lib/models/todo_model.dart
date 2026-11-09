class TodoModel {
  final String title;
  final bool isComplete;

  TodoModel({
    required this.title,
    required this.isComplete,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "isComplete": isComplete,
    };
  }

  TodoModel.fromMap(Map<String, dynamic> map) 
    : title = map["title"] ?? "",
      isComplete = map["isComplete"] ?? false;
}