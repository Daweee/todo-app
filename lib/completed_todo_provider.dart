import 'package:flutter/material.dart';
import 'todo_model.dart';

class CompletedTodoProvider with ChangeNotifier {
  List<Todo> completedTodos = [];

  void addCompletedTask(Todo todo) {
    completedTodos.add(todo);
    notifyListeners();
  }

  void removeCompletedTask(int taskId) {
    completedTodos.removeWhere((todo) => todo.id == taskId);
    notifyListeners();
  }
}
