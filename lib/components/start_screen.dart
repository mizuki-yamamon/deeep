import 'package:deep/components/gridtile.dart';
import 'package:deep/components/map_screen.dart';
import 'package:deep/components/todo_edit/todo_edit_view.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'search_screen.dart';
import 'tutorial_screen.dart';

class TodoListView extends StatefulWidget {
  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  String a = 'Todo';
  PackageInfo? _packageInfo;
  String formURL =
      'https://docs.google.com/forms/d/e/1FAIpQLScppcLpy3lsW0cT_5vp4tCBWI9xYsRbuooYrGVTIqNcc1LBDg/viewform?usp=sf_link';

  @override
  void initState() {
    a.contains('Td');
    // TODO: implement initState
    super.initState();
    _getPackageInfo();
    syncDataWithProvider();
  }

  Future syncDataWithProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getBool('FirstTime3');
    if (result == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TutorialScreen(),
        ),
      );

      setState(() {});
    }
  }

  _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  _settings() {
    showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.help),
                  title: Text('How to use it'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TutorialScreen(),
                      ),
                    ).then((value) => Navigator.pop(context));
                  }),
              ListTile(
                leading: Icon(Icons.support_agent),
                title: Text('request'),
                onTap: () async {
                  if (await canLaunch(formURL)) {
                    await launch(formURL, forceSafariVC: false);
                  } else {
                    print("error");
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Version: ${_packageInfo!.version}'),
                onTap: () => Navigator.of(context).pop(3),
              ),
            ],
          );
        });
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
                  backgroundColor: Colors.grey[100],
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {
                        _settings();
                      },
                      icon: Icon(
                        Icons.settings,
                        color: Colors.black,
                      )),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                        bloc: _bloc,
                                        alltodos: snapshot.data!,
                                      )));
                        },
                        icon: Icon(
                          Icons.map,
                          color: Colors.black,
                        )),
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
                          color: Colors.black,
                        ))
                  ],
                  //title: Text(ConstText.todoListView),
                ),
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
                            children: [
                              ..._content(_todoList, snapshot.data!),
                            ],
                            header: Card(
                              color: Colors.blue[300],
                              child: new InkWell(
                                onTap: () {
                                  Todo createTodo = Todo(
                                    id: Uuid().v4(),
                                    title: "",
                                    dueDate: DateTime.now(),
                                    note: "",
                                    checker: 0,
                                    number: snapshot.data!
                                            .where((element) =>
                                                element.tag == 'Todo')
                                            .toList()
                                            .isEmpty
                                        ? 0
                                        : snapshot.data!
                                                .where((element) =>
                                                    element.tag == 'Todo')
                                                .toList()[_todoList.length - 1]
                                                .number! +
                                            1,
                                    tag: 'Todo',
                                    model: 1, //マンダラをデフォルトに)
                                  );
                                  _bloc.create(createTodo);
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
                                          // todoList: _todoList,
                                          todoBloc: _bloc,
                                          todo: createTodo,

                                          alltodos: snapshot.data!,
                                          isCenter: false,
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
                              await _bloc.update(
                                _newtodo,
                              );
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
            0,
          ),
        )
        .toList();
  }
}
