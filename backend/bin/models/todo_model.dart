// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoModel {
  int id;
  String title;
  bool complete;
  TodoModel({
    required this.id,
    required this.title,
    required this.complete,
  });

  TodoModel copyWith({
    int? id,
    String? title,
    bool? complete,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      complete: complete ?? this.complete,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'complete': complete,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int,
      title: map['title'] as String,
      complete: map['complete'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TodoModel(id: $id, title: $title, complete: $complete)';

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title && other.complete == complete;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ complete.hashCode;
}
