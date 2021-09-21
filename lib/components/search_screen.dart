import 'package:deep/components/todo_list/mandala_grid.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/models/todo_data.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final TodoBloc? bloc;
  final List<Todo>? alltodos;
  SearchScreen({Key? key, @required this.bloc, @required this.alltodos})
      : super(key: key);

  @override
  _SearchScreenState createState() => new _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController editingController = TextEditingController();

  List<Todo> duplicateItems = [];
  List<Todo> items = [];

  @override
  void initState() {
    duplicateItems = widget.alltodos!;
    super.initState();
  }

  void filterSearchResults(String query) {
    List<Todo> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<Todo> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.title!.contains(query) && item.title!.isNotEmpty) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    return Consumer<TodoData>(builder: (context, model, child) {
      return new Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if (items[index].title!.isNotEmpty) {
                      return ListTile(
                        tileColor: Colors.white,
                        onTap: () {
                          model.updateTodo(items[index]);
                          model.updatePreTodo(items[index]);
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
                        },
                        title: Text(
                          '${items[index].title}',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
