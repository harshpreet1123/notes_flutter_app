final String tableNotes = 'notes';

class NotesField {
  static final List<String> values = [id, title, description, createdTime];

  static final String id = "_id";
  static final String title = "title";
  static final String description = "description";
  static final String createdTime = "createdTime";
}

class Note {
  int? id;
  final String title;
  final String description;
  final DateTime createdTime;

  Note(
      {this.id,
      required this.title,
      required this.description,
      required this.createdTime});

  Note copy(
      {int? id, String? title, String? description, DateTime? createdTime}) {
    return Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime);
  }

  static Note fromJson(Map<String,Object?> json) {
    return Note(
      id: json[NotesField.id] as int,
      title: json[NotesField.title] as String,
      description: json[NotesField.description] as String,
      createdTime: DateTime.parse(json[NotesField.createdTime] as String),
    );
  }

  Map<String, Object?> toJson() => {
        NotesField.id: id,
        NotesField.title: title,
        NotesField.description: description,
        NotesField.createdTime: createdTime.toIso8601String(),
      };
}
