class Todo {
  int? id;
  String title;
  bool isDone;
  Todo({this.id, required this.title, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {
      'id':id,'title':title
    };
  }

    factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
    );
  }

}
