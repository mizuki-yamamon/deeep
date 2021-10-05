import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'components/start_screen.dart';
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
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          // ],
          // supportedLocales: [
          //   const Locale("en", "US"),
          //   const Locale("ja", "JP")
          // ],
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
