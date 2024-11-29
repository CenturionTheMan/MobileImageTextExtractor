class NoteItem {
  String title;
  String content;
  String imagePath;

  NoteItem(
      {required this.title, required this.content, required this.imagePath});

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      title: json['title'],
      content: json['content'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imagePath': imagePath,
    };
  }
}
