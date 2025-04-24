class Note {
  final int? id;
  final String title;
  final String content;
  final String? imagePath;

  Note({this.id, required this.title, required this.content, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imagePath: map['imagePath'],
    );
  }
}