import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Todo {
  String? id;
  String? title;
  DateTime? dueDate;
  String? note;
  int? checker;
  int? number;
  String? tag;

  Todo({
    this.id,
    @required this.title,
    @required this.dueDate,
    @required this.note,
    @required this.checker,
    @required this.number,
    @required this.tag,
  });
  Todo.newTodo() {
    title = "";
    dueDate = DateTime.now();
    note = "";
    checker = 0;
    number = 0;
    tag = '';
  }

  // assignUUID() {
  //   id = Uuid().v4();
  // }

  // staticでも同じ？
  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        // DateTime型は文字列で保存されているため、DateTime型に変換し直す
        dueDate: DateTime.parse(json["dueDate"]).toLocal(),
        note: json["note"],
        checker: json["checker"],
        number: json["number"],
        tag: json["tag"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        // sqliteではDate型は直接保存できないため、文字列形式で保存する
        "dueDate": dueDate!.toUtc().toIso8601String(),
        "note": note,
        "checker": checker,
        "number": number,
        "tag": tag,
        // "check": check!.toUtc().toIso8601String(),
      };
}
