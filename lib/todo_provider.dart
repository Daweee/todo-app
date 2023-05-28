import 'package:flutter/foundation.dart';
import 'todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String task, String details) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      task: task,
      details: details,
    );
    _todos.add(newTodo);
    notifyListeners();
  }

  void removeTodoById(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void updateTodoById(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  void markAsCompleted(int id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final completedTodo = _todos[index];
      completedTodo.completed = true;
      notifyListeners();
    }
  }

  Todo getTodoById(int id) {
    return _todos.firstWhere((todo) => todo.id == id);
  }
}
