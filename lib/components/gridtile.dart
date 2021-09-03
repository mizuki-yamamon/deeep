import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/components/todo_list/layer_view.dart';
import 'package:deep/components/todo_list/mandala_grid.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridTiles extends StatelessWidget {
  final Todo todo;
  final List<Todo> alltodos;
  // final List<Todo> allTodos;
  final int index;

  GridTiles(
    Key key,
    this.todo,
    this.alltodos,
    //  this.allTodos,
    this.index,
  ) : super(key: key);

  var _usStates = ["何もしない", '削除する'];

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

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    return new Card(
      color: todo.checker == 0 ? Colors.white : Colors.blue[200],
      child: new InkWell(
        // onForcePressStart: (a) {
        //   Provider.of<TriggerData>(context, listen: false).trigger = true;
        // },
        // onLongPressEnd: (a) {
        //   Provider.of<TriggerData>(context, listen: false).trigger = false;
        // },

        onDoubleTap: () {
          print(todo.number);
          print(todo.tag);

          if (todo.title!.isEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TodoEditView(
                          number: todo.number,
                          //todoList: todos,
                          todoBloc: _bloc,
                          todo: todo,
                          label: todo.tag,
                        )));
          } else if (todo.model == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LayerView(
                  todo: todo, layer: 1, // bloc: _bloc,
                  //問題をtitleかtagsで分けるため
                ),
              ),
            );
          } else if (todo.model == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MandalaGridScreen(
                  todo: todo, layer: 1, bloc: _bloc,
                  //問題をtitleかtagsで分けるため
                ),
              ),
            );
          }

          // }
        },
        onTap: () {
          print(todo.number);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TodoEditView(
                        number: todo.number,
                        // todoList: todos,
                        todoBloc: _bloc,
                        todo: todo,
                        label: todo.tag,
                      )));
        },
        child: Stack(
          children: [
            new Center(
              child: new Padding(
                  padding: EdgeInsets.all(4.0),
                  child: new Text(
                    todo.title!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
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
                      child: Text(
                        s,
                        style: TextStyle(
                          // fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'font_1_honokamarugo_1.1',
                          color: s == '削除する' ? Colors.red : Colors.black,
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
    );
  }
}
