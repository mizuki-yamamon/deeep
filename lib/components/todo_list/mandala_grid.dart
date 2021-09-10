import 'package:deep/models/todo.dart';
import 'package:deep/models/todo_data.dart';
import 'package:deep/repositories/db_provider.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:deep/widgets/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';
import 'package:uuid/uuid.dart';

import '../gridtile.dart';
import '../search_screen.dart';

class MandalaGridScreen extends StatefulWidget {
  // final Todo todo;
  //final List<Todo> allTodo;
  final int layer;
  final TodoBloc bloc;

  MandalaGridScreen(
      {Key? key, //required this.todo,
      required this.layer,
      required this.bloc})
      : super(key: key);

  @override
  _MandalaGridScreenState createState() => _MandalaGridScreenState();
}

class _MandalaGridScreenState extends State<MandalaGridScreen>
    with TickerProviderStateMixin {
  int _counter = 0;
  AnimationController? controller;
  List<Todo> _allList = [];
  Todo? _todo;

  // Tag? _centerTag;

  // List<Tag> _aroundTags = [];

  int variableSet = 0;
  List<StaggeredTileExtended> _listStaggeredMandaraExtended =
      <StaggeredTileExtended>[
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
  ];
  List<StaggeredTileExtended> _listStaggeredLayerExtended =
      <StaggeredTileExtended>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _createTodo();

    // _createTodo();
    //  _createTodo();
  }

  @override
  void dispose() {
    super.dispose();
  }

//マンダラグリットがない時に生成
  _createTodo(Todo todo) async {
    print('object');
    List<Todo> thelist = await DBProvider.db.getAllTodos();
    thelist.where((element) => (todo.tag! + todo.id!) == element.tag).toList();
    print(thelist);
    print(thelist
        .where((element) => (todo.tag! + todo.id!) == element.tag)
        .toList());
    for (int i = thelist
            .where((element) => (todo.tag! + todo.id!) == element.tag)
            .toList()
            .length;
        i <= 7;
        i++) {
      widget.bloc.create(
        Todo(
            id: Uuid().v4(),
            title: '',
            note: '',
            dueDate: DateTime.now(),
            checker: 0,
            number: i,
            tag: todo.tag! + todo.id!,
            model: 1),
      );
    }
  }

  _content(Todo _centerTodo, List<Todo> _todoList, List<Todo> _allTodos,
      Todo preTodo) {
    double width = MediaQuery.of(context).size.width;

    return _todoList
        .asMap()
        .keys
        .toList()
        .map((index) => GridTiles(
              Key(_todoList[index].id!),
              _todoList[index],
              _centerTodo,
              index,
              _allTodos,
              1,
            ))
        .toList();
  }

  _appbarWidget(Todo todo, TodoBloc _bloc, List<Todo> alltodo) {
    return AppBar(
      backgroundColor: Colors.grey[100],
      centerTitle: true,
      title: Text(
        todo.tag == 'Todo'
            ? ('1層')
            : (((todo.tag!.length - 4) / 36) + 1).toStringAsFixed(0) + '層',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0.0,
      leading: IconButton(
          onPressed: () {
            Navigator.popUntil(
                context, (Route<dynamic> route) => route.isFirst);
          },
          icon: Icon(Icons.fast_rewind, color: Colors.black)),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchScreen(
                            bloc: _bloc,
                            alltodos: alltodo,
                          )));
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final _bloc = Provider.of<TodoBloc>(context, listen: false);

    _todo = Provider.of<TodoData>(context, listen: false).currentTodo;

    return Consumer<TodoData>(builder: (context, model, child) {
      print(model.currentTodo!.id);
      print('model.currentTodo!.id');
      if (model.currentTodo!.model == 1) {
        _createTodo(model.currentTodo!);
      }

      return StreamBuilder<List<Todo>>(
          stream: _bloc.todoStream,
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasData) {
              //_allList = snapshot.data!;
              List<Todo> _todoList = snapshot.data!
                  .where((element) =>
                      element.tag ==
                      model.currentTodo!.tag! + model.currentTodo!.id!)
                  .toList();
              Todo _centerTodo = snapshot.data!
                  .where((element) => element.id == model.currentTodo!.id)
                  .first;
              if (_centerTodo.model == 1) {
                if (_todoList.length > 7) {
                  _todoList.sort((a, b) => a.number!.compareTo(b.number!));
                  _todoList.insert(4, _centerTodo);
                  return Scaffold(
                      backgroundColor: Colors.grey[100],
                      appBar: _appbarWidget(
                          model.currentTodo!, _bloc, snapshot.data!),
                      body: Container(
                          width: width,
                          height: height,
                          color: Colors.grey[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height * 0.1,
                              ),
                              Expanded(
                                child: ReorderableItemsView(
                                  mainAxisSpacing: 0,
                                  children: [
                                    ..._content(_centerTodo, _todoList,
                                        snapshot.data!, model.currentTodo!)
                                  ],
                                  crossAxisCount: 3,
                                  isGrid: true,
                                  staggeredTiles: _listStaggeredMandaraExtended,
                                  longPressToDrag: true,
                                  onReorder:
                                      (int oldIndex, int newIndex) async {
                                    if (oldIndex == 4) {
                                      ShowFlushbar.showFloatingFlushbar(
                                          context, 'エラー', '中心は動かすことができません');
                                    } else {
                                      Todo _oldtodo = _todoList[oldIndex];
                                      Todo _newtodo = _todoList[newIndex];
                                      int _old = _oldtodo.number!;
                                      int _new = _newtodo.number!;
                                      _oldtodo.number = _new;
                                      _newtodo.number = _old;
                                      await _bloc.update(
                                        _oldtodo,
                                      );
                                      await _bloc.update(
                                        _newtodo,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )));
                } else {
                  _createTodo(_centerTodo);
                  return Scaffold(
                      backgroundColor: Colors.grey[100],
                      body: Center(child: CircularProgressIndicator()));
                }
              } else {
                _listStaggeredLayerExtended = [
                  StaggeredTileExtended.count(1, 1),
                  StaggeredTileExtended.count(1, 1),
                  StaggeredTileExtended.count(1, 1),
                ];
                snapshot.data!
                    .where((element) =>
                        element.tag ==
                        (model.currentTodo!.tag! + model.currentTodo!.id!))
                    .toList()
                    .forEach((element) {
                  _listStaggeredLayerExtended
                      .add(StaggeredTileExtended.count(1, 1));
                });
                _todoList.insert(0, _centerTodo);

                return Scaffold(
                    backgroundColor: Colors.grey[100],
                    appBar: _appbarWidget(
                        model.currentTodo!, _bloc, snapshot.data!),
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Expanded(
                          child: ReorderableItemsView(
                            children: [
                              ..._content(_centerTodo, _todoList,
                                  snapshot.data!, model.currentTodo!),
                            ],
                            header: Card(
                              color: Colors.blue[300],
                              child: new InkWell(
                                onTap: () {
                                  _bloc.create(Todo(
                                    id: Uuid().v4(),
                                    title: "",
                                    dueDate: DateTime.now(),
                                    note: "",
                                    checker: 0,
                                    number: _todoList[_todoList.length - 1]
                                            .number! +
                                        1,
                                    tag: _centerTodo.tag! + _centerTodo.id!,
                                    model: 1, //マンダラをデフォルトに)
                                  ));
                                  // _moveToCreateView(context, _bloc, _todoList);
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
                                  //         number: _todoList.isEmpty
                                  //             ? 0
                                  //             : _todoList[_todoList.length - 1]
                                  //                     .number! +
                                  //                 1,
                                  //         // todoList: _todoList,
                                  //         todoBloc: _bloc,
                                  //         todo: Todo.newTodo(),
                                  //         label: model.currentTodo!.tag! +
                                  //             model.currentTodo!.id!,
                                  //         alltodos: snapshot.data!,
                                  //         isCenter: ,
                                  //       );
                                  //     }).then((value) => print(value));
                                },
                                child: new Center(
                                  child: new Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                            crossAxisCount: 3,
                            isGrid: true,
                            staggeredTiles: _listStaggeredLayerExtended,
                            longPressToDrag: true,
                            onReorder: (int oldIndex, int newIndex) async {
                              if (oldIndex == 0) {
                                ShowFlushbar.showFloatingFlushbar(
                                    context, 'エラー', '親のセルは動かすことができません');
                              } else {
                                Todo _oldtodo = _todoList[oldIndex];
                                Todo _newtodo = _todoList[newIndex];
                                int _old = _oldtodo.number!;
                                int _new = _newtodo.number!;
                                _oldtodo.number = _new;
                                _newtodo.number = _old;
                                await _bloc.update(
                                  _oldtodo,
                                );
                                await _bloc.update(_newtodo);
                              }
                            },
                          ),
                        ),
                      ],
                    ));
              }
            } else {
              return Scaffold(
                  backgroundColor: Colors.grey[100],
                  body: Center(child: CircularProgressIndicator()));
            }
          });
    });
  }
  //     } else {
  //       _listStaggeredLayerExtended = [
  //         StaggeredTileExtended.count(1, 1),
  //         StaggeredTileExtended.count(1, 1),
  //         StaggeredTileExtended.count(1, 1)
  //       ];
  //       return StreamBuilder<List<Todo>>(
  //           stream: _bloc.todoStream,
  //           builder:
  //               (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
  //             if (snapshot.hasData) {
  //               List<Todo> _todoList = snapshot.data!
  //                   .where((element) =>
  //                       element.tag ==
  //                       (model.currentTodo!.tag! + model.currentTodo!.id!))
  //                   .toList();
  //               // _todoList.where((element) => element.tag == 'Todo').toList();
  //               _todoList.sort((a, b) => a.number!.compareTo(b.number!));

  //               Todo _centerTodo = snapshot.data!
  //                   .where((element) => element.id == model.currentTodo!.id)
  //                   .first;
  //               snapshot.data!
  //                   .where((element) =>
  //                       element.tag ==
  //                       (model.currentTodo!.tag! + model.currentTodo!.id!))
  //                   .toList()
  //                   .forEach((element) {
  //                 _listStaggeredLayerExtended
  //                     .add(StaggeredTileExtended.count(1, 1));
  //               });
  //               _todoList.insert(0, _centerTodo);
  //               return Scaffold(
  //                   backgroundColor: Colors.grey[100],
  //                   appBar: _appbarWidget(
  //                       model.currentTodo!, _bloc, snapshot.data!),
  //                   body: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       SizedBox(
  //                         height: 50,
  //                       ),
  //                       Expanded(
  //                         child: ReorderableItemsView(
  //                           children: [
  //                             ..._content(model.currentTodo!, _todoList,
  //                                 snapshot.data!),
  //                           ],
  //                           header: Card(
  //                             color: Colors.blue[300],
  //                             child: new InkWell(
  //                               onTap: () {
  //                                 _bloc.create(Todo.newTodo());
  //                                 // _moveToCreateView(context, _bloc, _todoList);
  //                                 // showModalBottomSheet(
  //                                 //     shape: RoundedRectangleBorder(
  //                                 //         borderRadius: BorderRadius.only(
  //                                 //             topRight: Radius.circular(20.0),
  //                                 //             topLeft: Radius.circular(20.0))),
  //                                 //     backgroundColor: Colors.white,
  //                                 //     context: context,
  //                                 //     isScrollControlled: true,
  //                                 //     builder: (context) {
  //                                 //       return TodoEditView(
  //                                 //         number: _todoList.isEmpty
  //                                 //             ? 0
  //                                 //             : _todoList[_todoList.length - 1]
  //                                 //                     .number! +
  //                                 //                 1,
  //                                 //         // todoList: _todoList,
  //                                 //         todoBloc: _bloc,
  //                                 //         todo: Todo.newTodo(),
  //                                 //         label: model.currentTodo!.tag! +
  //                                 //             model.currentTodo!.id!,
  //                                 //         alltodos: snapshot.data!,
  //                                 //         isCenter: ,
  //                                 //       );
  //                                 //     }).then((value) => print(value));
  //                               },
  //                               child: new Center(
  //                                 child: new Padding(
  //                                     padding: EdgeInsets.all(4.0),
  //                                     child: Icon(
  //                                       Icons.add,
  //                                       color: Colors.white,
  //                                     )),
  //                               ),
  //                             ),
  //                           ),
  //                           crossAxisCount: 3,
  //                           isGrid: true,
  //                           staggeredTiles: _listStaggeredLayerExtended,
  //                           longPressToDrag: true,
  //                           onReorder: (int oldIndex, int newIndex) async {
  //                             if (oldIndex == 0) {
  //                               ShowFlushbar.showFloatingFlushbar(
  //                                   context, 'エラー', '親のセルは動かすことができません');
  //                             } else {
  //                               Todo _oldtodo = _todoList[oldIndex];
  //                               Todo _newtodo = _todoList[newIndex];
  //                               int _old = _oldtodo.number!;
  //                               int _new = _newtodo.number!;
  //                               _oldtodo.number = _new;
  //                               _newtodo.number = _old;
  //                               await _bloc.update(
  //                                 _oldtodo,
  //                               );
  //                               await _bloc.update(_newtodo);
  //                             }
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ));
  //             } else {
  //               return Scaffold(
  //                   backgroundColor: Colors.grey[100],
  //                   body: Center(child: CircularProgressIndicator()));
  //             }
  //           });
  //     }
  //   });
  //}
}

//
