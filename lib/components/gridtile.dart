import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/components/todo_list/mandala_grid.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/models/todo_data.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridTiles extends StatefulWidget {
  final Todo todo;
  final Todo pretodo;
  final int index;
  final List<Todo> alltodos;
  final int type;

  GridTiles(
    Key key,
    this.todo,
    this.pretodo,
    this.index,
    this.alltodos,
    this.type,

    //  this.allTodos,
  ) : super(key: key);

  @override
  State<GridTiles> createState() => _GridTilesState();
}

class _GridTilesState extends State<GridTiles>
    with SingleTickerProviderStateMixin {
  var _options = ["何もしない", '削除する', 'チェック'];
  Animation? _animation;
  AnimationController? _animationController;

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();

    super.dispose();
  }

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
    if (widget.pretodo.tag == 'Todo' && widget.type == 0) {
      Future.delayed(new Duration(milliseconds: 180 * widget.index))
          .then((value) => _animationController!.forward());
    } else {
      if (widget.pretodo.model == 0) {
        //レイヤー型
        Future.delayed(new Duration(milliseconds: 180 * widget.index))
            .then((value) => _animationController!.forward());
      }
      if (widget.pretodo.model == 1) {
        Future.delayed(
                new Duration(milliseconds: 180 * (widget.index - 4).abs()))
            .then((value) => _animationController!.forward());
      }
    }

    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    return Consumer<TodoData>(builder: (context, model, child) {
      return FadeTransition(
        opacity: _animationController!,
        child: Hero(
            tag: 'tag' + widget.todo.id!,
            child: new Card(
              color: widget.todo.id == widget.pretodo.id && widget.type != 0
                  ? Colors.blue[300]
                  : Colors.white,
              child: new InkWell(
                onDoubleTap: () async {
                  print(widget.todo.number);
                  print(widget.todo.tag);

                  if (widget.todo.title!.isEmpty) {
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
                            //todoList: todos,
                            todoBloc: _bloc,
                            todo: widget.todo,
                            label: widget.todo.tag,
                            alltodos: widget.alltodos,
                          );
                        });
                  } else {
                    if (widget.type == 0) {
                      model.updateTodo(widget.todo);
                      model.updatePreTodo(widget.pretodo);
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
                      // }
                    } else {
                      if (widget.todo.id == widget.pretodo.id) {
                        if (widget.todo.tag == 'Todo') {
                          Navigator.pop(context);
                        } else {
                          print('korekore');

                          model.updateTodo(widget.alltodos
                              .where((element) =>
                                  element.id ==
                                  widget.todo.tag!.substring(
                                      widget.todo.tag!.length - 36,
                                      widget.todo.tag!.length))
                              .toList()
                              .cast<Todo>()
                              .first);
                          //model.updatePreTodo(widget.pretodo);
                          model.notify();
                        }
                      } else {
                        model.updatePreTodo(widget.pretodo);
                        model.updateTodo(widget.todo);
                        model.notify();
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
                          number: widget.todo.number,
                          // todoList: todos,
                          todoBloc: _bloc,
                          todo: widget.todo,
                          label: widget.todo.tag,
                          alltodos: widget.alltodos,
                        );
                      });
                  print(widget.todo.number);
                },
                child:
                    // Stack(
                    //   children: [
                    new Center(
                  child: new Padding(
                    padding: EdgeInsets.all(4.0),
                    child: new Text(
                      widget.todo.title!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.todo.id == widget.pretodo.id &&
                                  widget.type != 0
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            )),
      );
      // }
    });
  }
}
