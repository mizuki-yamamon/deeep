import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/components/todo_list/layer_view.dart';
import 'package:deep/components/todo_list/mandala_grid.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/models/todo_data.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridTiles extends StatelessWidget {
  final Todo todo;
  final Todo pretodo;
  final int index;
  final List<Todo> alltodos;
  final int type;
  // final List<Todo> allTodos;

  GridTiles(
    Key key,
    this.todo,
    this.pretodo,
    this.index,
    this.alltodos,
    this.type,

    //  this.allTodos,
  ) : super(key: key);

  var _options = ["何もしない", '削除する', 'チェック'];
  var _options2 = [
    "何もしない",
    '削除する',
  ];

  _delete(TodoBloc _bloc) async {
    await Future.forEach(alltodos, (Todo element) async {
      if (element.id == todo.id) {
        _bloc.delete(element.id!);
      }
      if (element.tag!.contains(todo.tag! + todo.id!)) {
        //  print(element.tag);
        _bloc.delete(element.id!);
      }
      // }
    });
    print('完了');
  }

  _colors() {
    if (type == 1 && index == 4) {}
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    return Consumer<TodoData>(builder: (context, model, child) {
      return Hero(
          tag: 'tag' + todo.id!,
          child: new Card(
            color: type == 1 && index == 4
                ? Colors.green[200]
                : type == 1 && todo.checker == 1
                    ? Colors.blue[200]
                    : Colors.white,
            child: new InkWell(
              // onForcePressStart: (a) {
              //   Provider.of<TriggerData>(context, listen: false).trigger = true;
              // },
              // onLongPressEnd: (a) {
              //   Provider.of<TriggerData>(context, listen: false).trigger = false;
              // },

              onDoubleTap: () async {
                print(todo.number);
                print(todo.tag);

                if (todo.title!.isEmpty) {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return TodoEditView(
                          number: todo.number,
                          //todoList: todos,
                          todoBloc: _bloc,
                          todo: todo,
                          label: todo.tag,
                        );
                      });

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TodoEditView(
                  //               number: todo.number,
                  //               //todoList: todos,
                  //               todoBloc: _bloc,
                  //               todo: todo,
                  //               label: todo.tag,
                  //             )));
                } else {
                  if (type == 0) {
                    if (todo.model == 0) {
                      model.updateTodo(todo);
                      model.updatePreTodo(pretodo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LayerView(
                            todo: todo, layer: 1, // bloc: _bloc,
                            //問題をtitleかtagsで分けるため
                          ),
                        ),
                      );
                      model.notify();
                    } else if (todo.model == 1) {
                      model.updateTodo(todo);
                      model.updatePreTodo(pretodo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MandalaGridScreen(
                            // todo: todo,
                            layer: 1, bloc: _bloc,
                            //問題をtitleかtagsで分けるため
                          ),
                        ),
                      );
                      model.notify();
                    }
                  } else {
                    if (todo.id == pretodo.id) {
                      if (todo.tag == 'Todo') {
                        Navigator.pop(context);
                      } else {
                        model.updateTodo(model.preTodo!);
                        model.notify();
                      }
                    }
                    // } else if (type == 1 && index == 4) {
                    //   model.updateTodo(pretodo);
                    //   model.notify();
                    // } else if (type == 2 && index == 0) {
                    //   model.updateTodo(pretodo);
                    //   model.notify();
                    // }
                    else {
                      model.updatePreTodo(pretodo);
                      model.updateTodo(todo);
                      model.notify();
                      // if (todo.model == 0) {
                      //   model.updateTodo(todo);
                      //   model.notify();

                      //   // Navigator.push(
                      //   //   context,
                      //   //   MaterialPageRoute(
                      //   //     builder: (_) => LayerView(
                      //   //       todo: todo, layer: 1, // bloc: _bloc,
                      //   //       //問題をtitleかtagsで分けるため
                      //   //     ),
                      //   //   ),
                      //   // );
                      // } else if (todo.model == 1) {
                      //   model.updateTodo(todo);
                      //   model.notify();
                      //   //Provider.of<TodoData>(context).currentTodo = todo;
                      //   // Navigator.push(
                      //   //   context,
                      //   //   MaterialPageRoute(
                      //   //     builder: (_) => MandalaGridScreen(
                      //   //       todo: todo, layer: 1, bloc: _bloc,
                      //   //       //問題をtitleかtagsで分けるため
                      //   //     ),
                      //   //   ),
                      //   // );
                      // }
                    }
                  }
                }

                // }
              },
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return TodoEditView(
                        number: todo.number,
                        // todoList: todos,
                        todoBloc: _bloc,
                        todo: todo,
                        label: todo.tag,
                      );
                    });
                print(todo.number);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => TodoEditView(
                //               number: todo.number,
                //               // todoList: todos,
                //               todoBloc: _bloc,
                //               todo: todo,
                //               label: todo.tag,
                //             )));
              },
              child: type == 1
                  ? Center(
                      child: new Padding(
                          padding: EdgeInsets.all(4.0),
                          child: new Text(
                            todo.title!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    index == 4 ? Colors.white : Colors.black),
                          )),
                    )
                  : Stack(
                      children: [
                        new Center(
                          child: new Padding(
                            padding: EdgeInsets.all(4.0),
                            child: new Text(
                              todo.title!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        type == 2 && index == 0
                            ? Container()
                            : Align(
                                alignment: Alignment.bottomRight,
                                child: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: Colors.black87,
                                    ),
                                    onSelected: (String s) {
                                      if (s == '削除する') {
                                        _delete(_bloc);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      if (type == 2) {
                                        return _options.map((String s) {
                                          return PopupMenuItem(
                                            child: s == 'チェック'
                                                ? StatefulBuilder(builder:
                                                    (context, setState) {
                                                    return Checkbox(
                                                        value: todo.checker == 0
                                                            ? false
                                                            : true,
                                                        onChanged: (cheack) {
                                                          _bloc.update(Todo(
                                                              id: todo.id,
                                                              title: todo.title,
                                                              dueDate:
                                                                  todo.dueDate,
                                                              note: todo.note,
                                                              checker: cheack ==
                                                                      false
                                                                  ? 0
                                                                  : 1,
                                                              number:
                                                                  todo.number,
                                                              tag: todo.tag,
                                                              model:
                                                                  todo.model));
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                  })
                                                : Text(
                                                    s,
                                                    style: TextStyle(
                                                      // fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'font_1_honokamarugo_1.1',
                                                      color: s == '削除する'
                                                          ? Colors.red
                                                          : Colors.black,
                                                    ),
                                                  ),
                                            value: s,
                                          );
                                        }).toList();
                                      } else {
                                        return _options2.map((String s) {
                                          return PopupMenuItem(
                                            child: Text(
                                              s,
                                              style: TextStyle(
                                                // fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'font_1_honokamarugo_1.1',
                                                color: s == '削除する'
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                            value: s,
                                          );
                                        }).toList();
                                      }
                                    }),
                              )
                      ],
                    ),
            ),
          ));
    });
  }
}
