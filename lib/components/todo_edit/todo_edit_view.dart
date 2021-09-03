import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:deep/configs/const_text.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/db_provider.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TodoEditView extends StatelessWidget {
  final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");
  //final List<Todo>? todoList;
  final int? number;

  final TodoBloc? todoBloc;
  final Todo? todo;
  final Todo? _newTodo = Todo.newTodo();
  final String? label;

  TodoEditView({
    Key? key,
    // @required this.todoList,
    @required this.number,
    @required this.todoBloc,
    @required this.todo,
    @required this.label,
  }) {
    // Dartでは参照渡しが行われるため、todoをそのまま編集してしまうと、
    // 更新せずにリスト画面に戻ったときも値が更新されてしまうため、
    // 新しいインスタンスを作る
    _newTodo!.id = todo!.id;
    _newTodo!.title = todo!.title;
    _newTodo!.dueDate = todo!.dueDate;
    _newTodo!.note = todo!.note;
    _newTodo!.number = number;
    _newTodo!.tag = label;
    _newTodo!.checker = todo!.checker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(ConstText.todoEditView)),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              _titleTextFormField(),
              _dueDateTimeFormField(),
              _noteTextFormField(),
              _confirmButton(context),
              Text(_newTodo!.tag!)
            ],
          ),
        ));
  }

  Widget _titleTextFormField() => TextFormField(
        decoration: InputDecoration(labelText: "タイトル"),
        initialValue: _newTodo!.title,
        onChanged: _setTitle,
      );

  void _setTitle(String title) {
    _newTodo!.title = title;
  }

  // ↓ https://pub.dev/packages/datetime_picker_formfield のサンプルから引用
  Widget _dueDateTimeFormField() => DateTimeField(
      format: _format,
      decoration: InputDecoration(labelText: "締切日"),
      initialValue: _newTodo!.dueDate ?? DateTime.now(),

      // onChanged: _setDueDate,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      });

  void _setDueDate(DateTime dt) {
    _newTodo!.dueDate = dt;
  }

  Widget _noteTextFormField() => TextFormField(
        decoration: InputDecoration(labelText: "メモ"),
        initialValue: _newTodo!.note,
        maxLines: 3,
        onChanged: _setNote,
      );

  void _setNote(String note) {
    _newTodo!.note = note;
    //_newTodo!.check = note;
  }

  Widget _confirmButton(BuildContext context) => RaisedButton.icon(
        icon: Icon(
          Icons.tag_faces,
          color: Colors.white,
        ),
        label: Text("決定"),
        onPressed: () {
          // print(_newTodo!.check.toString());
          if (_newTodo!.id == null) {
            // List<Todo> _mandalas = [];

            String _id = Uuid().v4();
            _newTodo!.id = _id;
            _newTodo!.tag = label;
            // DBProvider.db.initDB(_id);
            // if (todoList!.isNotEmpty) {
            //   _newTodo!.number = todoList![todoList!.length - 1].number! + 1;
            // }
            todoBloc!.create(
              _newTodo!,
            );
            // for (int i = 0; i < 8; i++) {
            //   todoBloc!.create(
            //     Todo(
            //         id: Uuid().v4(),
            //         title: '',
            //         note: '',
            //         dueDate: DateTime.now(),
            //         checker: 0,
            //         number: i,
            //         tag: _id),
            //   );
            // }
          } else {
            todoBloc!.update(_newTodo!);
          }

          Navigator.of(context).pop();
        },
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white,
      );
}
