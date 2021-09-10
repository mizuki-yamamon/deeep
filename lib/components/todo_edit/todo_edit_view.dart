import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:deep/widgets/link_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TodoEditView extends StatefulWidget {
  final int? number;

  final TodoBloc? todoBloc;
  final Todo? todo;
  final String? label;
  final List<Todo>? alltodos;
  final bool? isCenter;

  TodoEditView({
    Key? key,
    // @required this.todoList,
    @required this.number,
    @required this.todoBloc,
    @required this.todo,
    @required this.label,
    @required this.alltodos,
    @required this.isCenter,
  }) {
    // Dartでは参照渡しが行われるため、todoをそのまま編集してしまうと、
    // 更新せずにリスト画面に戻ったときも値が更新されてしまうため、
    // 新しいインスタンスを作る
    // _newTodo!.id = todo!.id;
    // _newTodo!.title = todo!.title;
    // _newTodo!.dueDate = todo!.dueDate;
    // _newTodo!.note = todo!.note;
    // _newTodo!.number = number;
    // _newTodo!.tag = label;
    // _newTodo!.checker = todo!.checker;
  }

  @override
  _TodoEditViewState createState() => _TodoEditViewState();
}

class _TodoEditViewState extends State<TodoEditView> {
  final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");

  Todo? _newTodo;
  bool _isCommenting = false;
  bool _chack = false;
//  int _type = 0;
  @override
  void initState() {
    print(widget.todo!.dueDate!);
    if (widget.todo!.id != null) {
      _newTodo = Todo(
          id: widget.todo!.id!,
          title: widget.todo!.title!,
          dueDate: widget.todo!.dueDate!,
          note: widget.todo!.note!,
          checker: widget.todo!.checker!,
          number: widget.number!,
          tag: widget.label!,
          model: widget.todo!.model!);
      _chack = widget.todo!.checker == 0 ? false : true;

      // _newTodo!.id = widget.todo!.id!;
      // _newTodo!.title = widget.todo!.title!;
      // _newTodo!.dueDate = widget.todo!.dueDate!;
      // _newTodo!.note = widget.todo!.note!;
      // _newTodo!.number = widget.number!;
      // _newTodo!.tag = widget.label!;
      // _newTodo!.checker = widget.todo!.checker!;
      // _newTodo!.model = widget.todo!.model!;
    } else {
      _newTodo = Todo.newTodo();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _isCommenting = !_isCommenting;
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.isCenter!
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            _delete();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.delete)),
                  // _confirmButton(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [_swichbutton(0), _swichbutton(1)],
                  ),
                  widget.isCenter!
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _newTodo!.checker =
                                  _newTodo!.checker == 0 ? 1 : 0;
                              widget.todoBloc!.update(_newTodo!);
                            });
                          },
                          icon: Icon(
                            Icons.check,
                            color: _newTodo!.checker == 0
                                ? Colors.grey
                                : Colors.green,
                          )),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _isCommenting == false
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: _newTodo!.title!.isEmpty
                                    ? Text('(Tap!)',
                                        style: TextStyle(
                                          fontFamily: 'font_1_honokamarugo_1.1',
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ))
                                    : LinkTextAtoms(
                                        text: _newTodo!.title,
                                        textStyle: TextStyle(
                                          fontFamily: 'font_1_honokamarugo_1.1',
                                          fontSize: 15,
                                          color: Colors.black,
                                        )),
                                // ),
                              ),
                            )
                          : Column(
                              children: [
                                _titleTextFormField(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.keyboard_arrow_down)),
                  // _confirmButton(context),
                  // IconButton(
                  //     onPressed: () {
                  //       _submit();
                  //     },
                  //     icon: Icon(
                  //       Icons.done,
                  //       color: Colors.green,
                  //     ))
                ],
              ),
            ],
          ),
          // ),
        ));
  }

  _delete() async {
    await Future.forEach(widget.alltodos!, (Todo element) async {
      if (element.id == widget.todo!.id) {
        widget.todoBloc!.delete(element.id!);
      }
      if (element.tag!.contains(widget.todo!.tag! + widget.todo!.id!)) {
        print(element.id);
        widget.todoBloc!.delete(element.id!);
      }
      // }
    });
    print('完了');
  }

  Widget _swichbutton(int type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _newTodo!.model = type;
          widget.todoBloc!.update(_newTodo!);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          // width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: _buttonColor(type)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
              children: type == 0
                  ? [
                      Icon(
                        Icons.layers,
                        color: _buttonColor(type),
                      ),
                      Text("レイヤー", style: TextStyle(color: _buttonColor(type))),
                    ]
                  : [
                      Icon(
                        Icons.apps,
                        color: _buttonColor(type),
                      ),
                      Text("マンダラ", style: TextStyle(color: _buttonColor(type))),
                    ]),
        ),
      ),
    );
  }

  _buttonColor(int type) {
    return _newTodo!.model == type ? Colors.blue : Colors.grey;
  }

  Widget _titleTextFormField() => TextFormField(
        style: TextStyle(color: Colors.black),
        autofocus: true, //キーボードを常に表示する
        decoration: InputDecoration(
          hintText: "note",
          border: InputBorder.none,
        ),
        initialValue: _newTodo!.title,
        onChanged: _setTitle,
        maxLength: null,
        maxLines: null,
      );

  void _setTitle(String title) {
    _newTodo!.title = title;
    widget.todoBloc!.update(_newTodo!);
  }

  _submit() {
    // if (_newTodo!.title!.isNotEmpty) {
    if (_newTodo!.id == null) {
      //新規作成
      // List<Todo> _mandalas = [];
      String _id = Uuid().v4();
      _newTodo!.id = _id;
      _newTodo!.tag = widget.label;
      widget.todoBloc!.create(
        _newTodo!,
      );
    } else {
      widget.todoBloc!.update(_newTodo!);
    }
    //}
    Navigator.pop(context);
  }

  // Widget _dueDateTimeFormField() => DateTimeField(
  //     format: _format,
  //     decoration: InputDecoration(labelText: "締切日"),
  //     initialValue: _newTodo!.dueDate ?? DateTime.now(),

  //     // onChanged: _setDueDate,
  //     onShowPicker: (context, currentValue) async {
  //       final date = await showDatePicker(
  //           context: context,
  //           firstDate: DateTime(2000),
  //           initialDate: currentValue ?? DateTime.now(),
  //           lastDate: DateTime(2100));
  //       if (date != null) {
  //         final time = await showTimePicker(
  //           context: context,
  //           initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
  //         );
  //         return DateTimeField.combine(date, time);
  //       } else {
  //         return currentValue;
  //       }
  //     });

  // void _setDueDate(DateTime dt) {
  //   _newTodo!.dueDate = dt;
  // }

  // Widget _noteTextFormField() => TextFormField(
  //       decoration: InputDecoration(labelText: "メモ"),
  //       initialValue: _newTodo!.note,
  //       maxLines: 3,
  //       onChanged: _setNote,
  //     );

  // void _setNote(String note) {
  //   _newTodo!.note = note;
  //   //_newTodo!.check = note;
  // }
}
