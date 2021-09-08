import 'package:deep/components/gridtile.dart';
import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/configs/const_text.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';

import '../search_screen.dart';

class TodoListView extends StatefulWidget {
  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  String a = 'Todo';

  @override
  void initState() {
    a.contains('Td');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<StaggeredTileExtended> _listStaggeredTileExtended =
        <StaggeredTileExtended>[
      StaggeredTileExtended.count(1, 1),
    ];
    final _bloc = Provider.of<TodoBloc>(context, listen: false);

    return StreamBuilder<List<Todo>>(
        stream: _bloc.todoStream,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            List<Todo> _todoList = snapshot.data!
                .where((element) => element.tag == 'Todo')
                .toList();
            // _todoList.where((element) => element.tag == 'Todo').toList();
            _todoList.sort((a, b) => a.number!.compareTo(b.number!));

            _todoList.forEach((element) {
              _listStaggeredTileExtended.add(StaggeredTileExtended.count(1, 1));
            });

            return Scaffold(
                appBar: AppBar(
                  // backgroundColor: Colors.grey[100],
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        //color: Colors.black,
                      )),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                        bloc: _bloc,
                                        alltodos: snapshot.data!,
                                      )));
                        },
                        icon: Icon(
                          Icons.search,
                          // color: Colors.black,
                        ))
                  ],
                  //title: Text(ConstText.todoListView),
                ),
                body: Container(
                  width: width,
                  height: height,
                  //color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Expanded(
                        child: ReorderableItemsView(
                            children: [
                              ..._content(_todoList, snapshot.data!),
                            ],
                            header: Card(
                              color: Colors.blue[300],
                              child: new InkWell(
                                onTap: () {
                                  // _moveToCreateView(context, _bloc, _todoList);
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
                                          number: _todoList.isEmpty
                                              ? 0
                                              : _todoList[_todoList.length - 1]
                                                      .number! +
                                                  1,
                                          // todoList: _todoList,
                                          todoBloc: _bloc,
                                          todo: Todo.newTodo(),
                                          label: 'Todo',
                                        );
                                      });
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
                            // itemCount: snapshot.data!.length,
                            // itemBuilder: (BuildContext context, int index) {
                            //Todo todo = snapshot.data![index];

                            // return Dismissible(
                            //   key: Key(todo.id!),
                            //   background: _backgroundOfDismissible(),
                            //   secondaryBackground: _secondaryBackgroundOfDismissible(),
                            //   onDismissed: (direction) {
                            //     _bloc.delete(todo.id!);
                            //   },
                            //   child: Card(
                            //       child: ListTile(
                            //     onTap: () {
                            //       _moveToEditView(context, _bloc, todo);
                            //     },
                            //     title: Text("${todo.title}"),
                            //     subtitle: Text("${todo.note}"),
                            //     trailing: Text("${todo.dueDate!.toLocal().toString()}"),
                            //     isThreeLine: true,
                            //   )),
                            // );
                            //},
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
                              // if ((oldIndex - newIndex).abs() == 1) {
                              //   //隣同士
                              //   _todoList.insert(newIndex, _todoList.removeAt(oldIndex));
                              //   // _bloc.update(_todoList);
                              // } else if (newIndex < oldIndex) {

                              //   _todoList.insert(newIndex, _todoList.removeAt(oldIndex));
                              //   _todoList.insert(oldIndex, _todoList.removeAt(newIndex + 1));
                              // } else if (newIndex > oldIndex) {
                              //   _todoList.insert(newIndex, _todoList.removeAt(oldIndex));
                              //   _todoList.insert(oldIndex, _todoList.removeAt(newIndex - 1));

                              //   //_tiles.insert(oldIndex - 1, _tiles.removeAt(newIndex));
                              // }
                              //}
                              // else{
                              //   return Center(child: CircularProgressIndicator());
                              // },)

                              // floatingActionButton: FloatingActionButton(
                              //   onPressed: () {
                              //     _moveToCreateView(context, _bloc);
                              //   },
                              //   child: Icon(Icons.add, size: 40),
                              // ),
                              // );
                            }),
                      ),
                    ],
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _content(
    // Todo _pretodo,
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
              _todoList[index],
              index,
              // _todoList,
              _allTodos,
              0),
        )
        // _Example01Tile(Key(_tags[index].id!), _tags[index],
        //     _tags, index, widget.firstTag.id!))
        .toList();
  }
}
