import 'package:deep/components/gridtile.dart';
import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/configs/const_text.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';

class LayerView extends StatefulWidget {
  final Todo todo;
  //final List<Todo> allTodo;
  final int layer;

  LayerView({
    Key? key,
    required this.todo,
    required this.layer,
  }) : super(key: key);
  @override
  _LayerViewState createState() => _LayerViewState();
}

class _LayerViewState extends State<LayerView> {
  String a = 'Todo';

  @override
  void initState() {
    a.contains('Td');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<StaggeredTileExtended> _listStaggeredTileExtended =
        <StaggeredTileExtended>[
      StaggeredTileExtended.count(1, 1),
    ];
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        //title: Text(ConstText.todoListView),
        leading: IconButton(
            onPressed: () {
              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
            },
            icon: Icon(Icons.fast_rewind)),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _bloc.todoStream,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            List<Todo> _todoList = snapshot.data!
                .where((element) =>
                    element.tag == (widget.todo.tag! + widget.todo.id!))
                .toList();
            // _todoList.where((element) => element.tag == 'Todo').toList();
            _todoList.sort((a, b) => a.number!.compareTo(b.number!));
            Todo _centerTodo = snapshot.data!
                .where((element) => element.id == widget.todo.id)
                .first;
            _todoList.forEach((element) {
              _listStaggeredTileExtended.add(StaggeredTileExtended.count(1, 1));
            });
            // for (int i = 0; i <= _todoList.length; i++) {
            //   _listStaggeredTileExtended.add(StaggeredTileExtended.count(1, 1));
            // }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width * 0.3,
                    height: width * 0.3,
                    child: Card(
                      color: Colors.white,
                      child: new InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => TodoEditView(
                          //               number: _centerTodo.number,
                          //               //todoList: _todoList,
                          //               todoBloc: _bloc,
                          //               todo: _centerTodo,
                          //               label: _centerTodo.tag,
                          //             )));
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
                                  number: _centerTodo.number,
                                  //todoList: _todoList,
                                  todoBloc: _bloc,
                                  todo: _centerTodo,
                                  label: _centerTodo.tag,
                                );
                              });
                        },
                        onDoubleTap: () {
                          Navigator.pop(context);
                        },
                        child: new Center(
                            child: Hero(
                          tag: 'tag' + widget.todo.id!,
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              _centerTodo.title!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ReorderableItemsView(
                    children: [
                      ..._content(_todoList, snapshot.data!),
                    ],
                    header: Card(
                      color: Colors.blue[400],
                      child: new InkWell(
                        onTap: () {
                          _moveToCreateView(context, _bloc, _todoList);
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
                    staggeredTiles: _listStaggeredTileExtended,
                    longPressToDrag: true,
                    onReorder: (int oldIndex, int newIndex) async {
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
                    },
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _moveToCreateView(context, _bloc);
      //   },
      //   child: Icon(Icons.add, size: 40),
      // ),
    );
  }

  _content(
    List<Todo> _todoList,
    List<Todo> _allTodos,
  ) {
    //double width = MediaQuery.of(context).size.width;
    return _todoList
        .asMap()
        .keys
        .toList()
        .map(
          (index) => GridTiles(
            Key(_todoList[index].id!),
            _todoList[index],
            _allTodos,
          ),
        )
        // _Example01Tile(Key(_tags[index].id!), _tags[index],
        //     _tags, index, widget.firstTag.id!))
        .toList();
  }

  _moveToCreateView(
          BuildContext context, TodoBloc bloc, List<Todo> _todoList) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TodoEditView(
                    number: _todoList.isEmpty
                        ? 0
                        : _todoList[_todoList.length - 1].number! + 1,
                    // todoList: _todoList,
                    todoBloc: bloc,
                    todo: Todo.newTodo(),
                    label: widget.todo.tag! + widget.todo.id!,
                  )));
}
