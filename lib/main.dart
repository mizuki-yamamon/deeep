import 'package:deep/repositories/db_provider.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'components/todo_list/todo_list_view.dart';
import 'configs/const_text.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // DBProvider.db.initDB();
  //DBProvider.db.initDB('a' + Uuid().v4().replaceAll("-", ""));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Provider<TodoBloc>(
      create: (context) => new TodoBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: ConstText.appTitle,
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          // ダークモード対応
          darkTheme: ThemeData(brightness: Brightness.dark),
          home: TodoListView()),
    );
  }
}
