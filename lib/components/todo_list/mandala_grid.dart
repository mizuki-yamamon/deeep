import 'package:deep/components/mandaraTile.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/db_provider.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:deep/widgets/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';
import 'package:uuid/uuid.dart';

import '../gridtile.dart';

class MandalaGridScreen extends StatefulWidget {
  final Todo todo;
  //final List<Todo> allTodo;
  final int layer;
  final TodoBloc bloc;

  MandalaGridScreen(
      {Key? key, required this.todo, required this.layer, required this.bloc})
      : super(key: key);

  @override
  _MandalaGridScreenState createState() => _MandalaGridScreenState();
}

class _MandalaGridScreenState extends State<MandalaGridScreen>
    with TickerProviderStateMixin {
  int _counter = 0;
  AnimationController? controller;
  List<Todo> _allList = [];

  // Tag? _centerTag;

  // List<Tag> _aroundTags = [];

  int variableSet = 0;
  List<StaggeredTileExtended> _listStaggeredTileExtended =
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
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(1, 1),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createTodo();

    // _createTodo();
    //  _createTodo();
  }

  @override
  void dispose() {
    super.dispose();
  }

//マンダラグリットがない時に生成
  _createTodo() async {
    print('object');
    List<Todo> thelist = await DBProvider.db.getAllTodos();
    thelist
        .where((element) => (widget.todo.tag! + widget.todo.id!) == element.tag)
        .toList();
    print(thelist);
    print(thelist
        .where((element) => (widget.todo.tag! + widget.todo.id!) == element.tag)
        .toList());
    for (int i = thelist
            .where((element) =>
                (widget.todo.tag! + widget.todo.id!) == element.tag)
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
            tag: widget.todo.tag! + widget.todo.id!,
            model: 1),
      );
    }
  }

  _content(List<Todo> _todoList, List<Todo> _allTodos) {
    double width = MediaQuery.of(context).size.width;

    return _todoList
        .asMap()
        .keys
        .toList()
        .map((index) => MandaraTiles(
              Key(_todoList[index].id!),
              _todoList[index],
              _todoList,
              //  _allTodos,
              index,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final _bloc = Provider.of<TodoBloc>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        centerTitle: true,
        title: Text(
          widget.layer.toString() + '層目',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
            },
            icon: Icon(Icons.fast_rewind, color: Colors.black)),
        // Here we take the value from the LayerGridScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text('Map'),
        actions: [],
      ),
      body: StreamBuilder<List<Todo>>(
          stream: _bloc.todoStream,
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasData) {
              //_allList = snapshot.data!;
              List<Todo> _todoList = snapshot.data!
                  .where((element) =>
                      element.tag == widget.todo.tag! + widget.todo.id!)
                  .toList();
              Todo _centerTodo = snapshot.data!
                  .where((element) => element.id == widget.todo.id)
                  .first;

              if (_todoList.length > 4) {
                _todoList.sort((a, b) => a.number!.compareTo(b.number!));
                _todoList.insert(4, _centerTodo);
                return Container(
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
                            ..._content(_todoList, snapshot.data!)
                            // .insert(
                            //     4,
                            //     CenterTile(
                            //       Key(widget.todo.id!),
                            //       widget.todo,
                            //     )),
                          ],
                          crossAxisCount: 3,
                          isGrid: true,
                          staggeredTiles: _listStaggeredTileExtended,
                          longPressToDrag: true,
                          onReorder: (int oldIndex, int newIndex) async {
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
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class CenterTile extends StatelessWidget {
  final Todo todo;

  CenterTile(
    Key key,
    this.todo,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    return new Card(
      color: todo.checker == 0 ? Colors.white : Colors.blue[200],
      child: new InkWell(
        onDoubleTap: () {
          Navigator.pop(context);
        },
        onTap: () {
          print(todo.number);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => TodoEditView(
          //             todoList: todos,
          //             todoBloc: _bloc,
          //             todo: todo,
          //             label: label)));
        },
        child:
            // Stack(
            //   children: [
            new Center(
          child: new Padding(
              padding: EdgeInsets.all(4.0),
              child: new Text(
                todo.title!,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
        // Align(
        //     alignment: Alignment.bottomRight,
        //     child: IconButton(
        //         onPressed: () {
        //           _bloc.delete(todo.id!, label);
        //         },
        //         icon: Icon(Icons.delete //more_horiz),
        //             )))
        //   ],
        // ),
      ),
    );
  }
}
