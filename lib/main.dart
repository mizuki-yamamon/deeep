import 'package:deep/repositories/db_provider.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'components/todo_list/todo_list_view.dart';
import 'configs/const_text.dart';
import 'models/todo_data.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoData>(create: (context) => TodoData()),
        Provider<TodoBloc>(
          create: (context) => new TodoBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: ConstText.appTitle,
          theme: ThemeData(
            primaryColor: Colors.grey[100],
            backgroundColor: Colors.grey[100],
            brightness: Brightness.light,
            iconTheme: const IconThemeData.fallback().copyWith(
              color: Colors.black,
            ),
          ),
          // ダークモード対応
          // darkTheme: ThemeData(
          //   primaryColor: Colors.black,
          //   backgroundColor: Colors.black,
          //   brightness: Brightness.dark,
          //   iconTheme: const IconThemeData.fallback().copyWith(
          //     color: Colors.white,
          //   ),
          // ),
          themeMode: ThemeMode.system,
          home: TodoListView()),
    );
  }
}
