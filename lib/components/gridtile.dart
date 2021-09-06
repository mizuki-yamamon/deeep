import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/components/todo_list/layer_view.dart';
import 'package:deep/components/todo_list/mandala_grid.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridTiles extends StatefulWidget {
  final Todo todo;
  final List<Todo> alltodos;

  // final List<Todo> allTodos;

  GridTiles(
    Key key,
    this.todo,
    this.alltodos,
    //  this.allTodos,
  ) : super(key: key);

  @override
  _GridTilesState createState() => _GridTilesState();
}

class _GridTilesState extends State<GridTiles> {
  var _usStates = ["何もしない", '削除する', 'チェック'];

  _delete(TodoBloc _bloc) async {
    await Future.forEach(widget.alltodos, (Todo element) async {
      if (element.id == widget.todo.id) {
        _bloc.delete(element.id!);
      }
      if (element.tag!.contains(widget.todo.tag! + widget.todo.id!)) {
        //  print(element.tag);
        _bloc.delete(element.id!);
      }
      // }
    });
    print('完了');
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    return Hero(
      tag: 'tag' + widget.todo.id!,
      child: new Card(
        color: widget.todo.checker == 0 ? Colors.white : Colors.blue[200],
        child: new InkWell(
          // onForcePressStart: (a) {
          //   Provider.of<TriggerData>(context, listen: false).trigger = true;
          // },
          // onLongPressEnd: (a) {
          //   Provider.of<TriggerData>(context, listen: false).trigger = false;
          // },

          onDoubleTap: () async {
            print(widget.todo.number);
            print(widget.todo.tag);

            if (widget.todo.title!.isEmpty) {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return TodoEditView(
                      number: widget.todo.number,
                      //todoList: todos,
                      todoBloc: _bloc,
                      todo: widget.todo,
                      label: widget.todo.tag,
                    );
                  });

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => TodoEditView(
              //               number: widget.todo.number,
              //               //todoList: todos,
              //               todoBloc: _bloc,
              //               todo: widget.todo,
              //               label: widget.todo.tag,
              //             )));
            } else if (widget.todo.model == 0) {
              //await new Future.delayed(const Duration(milliseconds: 500));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LayerView(
                    todo: widget.todo, layer: 1, // bloc: _bloc,
                    //問題をtitleかtagsで分けるため
                  ),
                ),
              );
            } else if (widget.todo.model == 1) {
              //await new Future.delayed(const Duration(milliseconds: 500));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MandalaGridScreen(
                    todo: widget.todo, layer: 1, bloc: _bloc,
                    //問題をtitleかtagsで分けるため
                  ),
                ),
              );
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
                    number: widget.todo.number,
                    // todoList: todos,
                    todoBloc: _bloc,
                    todo: widget.todo,
                    label: widget.todo.tag,
                  );
                });
            print(widget.todo.number);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => TodoEditView(
            //               number: widget.todo.number,
            //               // todoList: todos,
            //               todoBloc: _bloc,
            //               todo: widget.todo,
            //               label: widget.todo.tag,
            //             )));
          },
          child: Stack(
            children: [
              new Center(
                child: new Padding(
                  padding: EdgeInsets.all(4.0),
                  child: new Text(
                    widget.todo.title!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
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
                    return _usStates.map((String s) {
                      return PopupMenuItem(
                        child: s == 'チェック'
                            ? StatefulBuilder(builder: (context, setState) {
                                return Checkbox(
                                    value:
                                        widget.todo.checker == 0 ? false : true,
                                    onChanged: (cheack) {
                                      _bloc.update(Todo(
                                          id: widget.todo.id,
                                          title: widget.todo.title,
                                          dueDate: widget.todo.dueDate,
                                          note: widget.todo.note,
                                          checker: cheack == false ? 0 : 1,
                                          number: widget.todo.number,
                                          tag: widget.todo.tag,
                                          model: widget.todo.model));
                                      Navigator.pop(context);
                                    });
                              })
                            : Text(
                                s,
                                style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'font_1_honokamarugo_1.1',
                                  color:
                                      s == '削除する' ? Colors.red : Colors.black,
                                ),
                              ),
                        value: s,
                      );
                    }).toList();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
