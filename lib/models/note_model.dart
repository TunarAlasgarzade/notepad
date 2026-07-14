class NoteModel {
  final String title;
  final String note;

  NoteModel({
    required this.title,
    required this.note
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title, 
      "note": note,
    };
  }
  NoteModel.fromMap(Map<String, dynamic> map)
      : title = map["title"] ?? "",
        note = map["note"] ?? "";
}