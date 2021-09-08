import 'package:deep/models/todo.dart';
import 'package:flutter/foundation.dart';

class TodoData extends ChangeNotifier {
  Todo? currentTodo;
  Todo? preTodo;
  void updateTodo(Todo str) {
    currentTodo = str;
    // 変更通知
    notifyListeners();
  }

  void updatePreTodo(Todo str) {
    preTodo = str;
    // 変更通知
    notifyListeners();
  }

  void notify() {
    notifyListeners(); // Providerを介してConsumer配下のWidgetがリビルドされる
  }
}
