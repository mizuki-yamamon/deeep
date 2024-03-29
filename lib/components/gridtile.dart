import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/components/todo_list/mandala_grid.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/models/todo_data.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  AnimationController? _animationController;

  bool _isAnime = false;

  @override
  void initState() {
    super.initState();

    _syncDataWithProvider();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future _syncDataWithProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getBool('Anime');
    if (result != null) {
      print(result);
      setState(() {
        _isAnime = result;
      });
    }
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

  _cardColor() {
    if (widget.todo.id == widget.pretodo.id && widget.type != 0) {
      return Colors.blue[300];
    }
    // if (widget.todo.checker == 1) {
    //   return Colors.green[300];
    // }
    else {
      return Colors.white;
    }
  }

  _textColor() {
    if (widget.todo.id == widget.pretodo.id && widget.type != 0) {
      return Colors.white;
    }
    if (widget.todo.checker == 1) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Widget _cardWidget(TodoData model, TodoBloc _bloc) {
    return Hero(
      tag: 'tag' + widget.todo.id!,
      child: new Card(
        color: _cardColor(),
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
                      //todoList: todos,
                      todoBloc: _bloc,
                      todo: widget.todo,

                      alltodos: widget.alltodos,
                      isCenter: widget.todo.id == widget.pretodo.id &&
                              widget.type != 0
                          ? true
                          : false,
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
                      //todoList: todos,
                      todoBloc: _bloc,
                      todo: widget.todo,

                      alltodos: widget.alltodos,
                      isCenter: widget.todo.id == widget.pretodo.id &&
                              widget.type != 0
                          ? true
                          : false,
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
            // showModalBottomSheet(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.only(
            //             topRight: Radius.circular(20.0),
            //             topLeft: Radius.circular(20.0))),
            //     backgroundColor: Colors.white,
            //     context: context,
            //     isScrollControlled: true,
            //     builder: (context) {
            //       return TodoEditView(
            //         // todoList: todos,
            //         todoBloc: _bloc,
            //         todo: widget.todo,

            //         alltodos: widget.alltodos,
            //         isCenter: widget.todo.id == widget.pretodo.id &&
            //                 widget.type != 0
            //             ? true
            //             : false,
            //       );
            //     });
            // print(widget.todo.number);
          },
          child: Stack(
            children: [
              new Center(
                child: new Padding(
                  padding: EdgeInsets.all(4.0),
                  child: new Text(
                    widget.todo.title!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: _textColor()),
                  ),
                ),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.95), // Button color
                    child: InkWell(
                        splashColor: Colors.blue, // Splash color
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
                                  // todoList: todos,
                                  todoBloc: _bloc,
                                  todo: widget.todo,

                                  alltodos: widget.alltodos,
                                  isCenter:
                                      widget.todo.id == widget.pretodo.id &&
                                              widget.type != 0
                                          ? true
                                          : false,
                                );
                              });
                          print(widget.todo.number);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.history_edu_outlined, //expand_less,
                            size: MediaQuery.of(context).size.width * 0.03 + 10,
                            color: Colors.black26,
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _animeWidget(TodoData model, TodoBloc _bloc, String _newTodoId) {
  //   print('変更前');
  //   print(_oldTodoId);
  //   print(_newTodoId);
  //   if (_newTodoId != _oldTodoId) {
  //     _oldTodoId = _newTodoId;

  //     print('変更された');
  //     print(_oldTodoId);
  //     print(_newTodoId);
  //     // if (widget.pretodo.tag == 'Todo' && widget.type == 0) {
  //     //   Future.delayed(new Duration(milliseconds: 50 * widget.index))
  //     //       .then((value) => _animationController!.forward());
  //     // } else {
  //     if (widget.pretodo.model == 0) {
  //       //レイヤー型
  //       Future.delayed(new Duration(milliseconds: 50 * widget.index))
  //           .then((value) => _animationController!.forward());
  //     }
  //     if (widget.pretodo.model == 1) {
  //       Future.delayed(
  //               new Duration(milliseconds: 50 * (widget.index - 4).abs()))
  //           .then((value) => _animationController!.forward());
  //     }
  //     // }
  //     return FadeTransition(
  //         opacity: _animationController!, child: _cardWidget(model, _bloc));
  //   } else {
  //     return _cardWidget(model, _bloc);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);

    return Consumer<TodoData>(builder: (context, model, child) {
      if (_isAnime) {
        if (widget.pretodo.model == 0) {
          //レイヤー型
          Future.delayed(new Duration(milliseconds: 100 * widget.index))
              .then((value) => _animationController!.forward());
        }
        if (widget.pretodo.model == 1) {
          Future.delayed(
                  new Duration(milliseconds: 100 * (widget.index - 4).abs()))
              .then((value) => _animationController!.forward());
          //_setAnime();
        }
        return FadeTransition(
            opacity: _animationController!, child: _cardWidget(model, _bloc));
      } else {
        return _cardWidget(model, _bloc);
      }
    });
  }
}
