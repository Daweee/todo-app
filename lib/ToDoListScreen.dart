// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'completed_todo_provider.dart';
import 'todo_provider.dart';
import 'todo_model.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

Widget myList(
  String task,
  String details,
  bool completed,
  VoidCallback onEdit,
  VoidCallback onDelete,
  ValueChanged<bool?>? onCheckboxChanged,
) {
  return Card(
    elevation: 5.0,
    color: Colors.grey[850],
    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        title: Text(
          task,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Colors.white,
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          details,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            color: Colors.white,
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: completed,
              onChanged: onCheckboxChanged,
              activeColor: Colors.blue,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    ),
  );
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  void showAlertDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff36454F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text(
          "Add task",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: taskController,
              autofocus: true,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
              decoration: const InputDecoration(
                hintText: 'Task',
              ),
            ),
            TextField(
              controller: detailsController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
              decoration: const InputDecoration(
                hintText: 'Task Details',
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff424952)),
                  ),
                  onPressed: () {
                    final String task = taskController.text.trim();
                    final String details = detailsController.text.trim();
                    if (task.isNotEmpty) {
                      final todoProvider =
                          Provider.of<TodoProvider>(context, listen: false);
                      todoProvider.addTodo(task, details);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ADD",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTodoList(List<Todo> todos) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Dismissible(
            key: Key(todo.id.toString()),
            onDismissed: (direction) {
              todoProvider.removeTodoById(todo.id);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: myList(
              todo.task,
              todo.details,
              todo.completed,
              () {
                onEditTask(todo.id, todo.task, todo.details);
              },
              () {
                todoProvider.removeTodoById(todo.id);
              },
              (completed) {
                onCheckboxChanged(todo.id, completed);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = todoProvider.todos;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAlertDialog(context),
        backgroundColor: const Color(0xff36454F),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "To-Do List",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.black45,
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildTodoList(todos),
          ],
        ),
      ),
    );
  }

  void onCheckboxChanged(int taskId, bool? completed) {
    if (completed != null) {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      final updatedTodo = todoProvider.getTodoById(taskId);

      // ignore: unnecessary_null_comparison
      if (updatedTodo != null) {
        updatedTodo.completed = completed;
        todoProvider.updateTodoById(updatedTodo);

        if (completed) {
          todoProvider.removeTodoById(updatedTodo.id);
          final completedTodoProvider =
              Provider.of<CompletedTodoProvider>(context, listen: false);
          completedTodoProvider.addCompletedTask(updatedTodo);
        }
      }
    }
  }

  void onEditTask(int taskId, String currentTask, String currentDetails) {
    final TextEditingController taskController =
        TextEditingController(text: currentTask);
    final TextEditingController detailsController =
        TextEditingController(text: currentDetails);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff36454F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text(
          "Edit task",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: taskController,
              autofocus: true,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextField(
              controller: detailsController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
              decoration: const InputDecoration(
                hintText: 'Task Details',
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff424952)),
                  ),
                  onPressed: () {
                    final String updatedTask = taskController.text.trim();
                    final String updatedDetails = detailsController.text.trim();
                    if (updatedTask.isNotEmpty) {
                      final todoProvider =
                          Provider.of<TodoProvider>(context, listen: false);
                      final updatedTodo = Todo(
                        id: taskId,
                        task: updatedTask,
                        details: updatedDetails,
                      );
                      todoProvider.updateTodoById(updatedTodo);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "SAVE",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCompletedTasksList() {
    final todoProvider = Provider.of<TodoProvider>(context);
    final completedTasks =
        todoProvider.todos.where((task) => task.completed).toList();

    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return myList(
            task.task,
            task.details,
            task.completed,
            () {
              // Handle edit functionality if needed
            },
            () {
              // Handle delete functionality if needed
            },
            (completed) {
              // Handle checkbox change if needed
            },
          );
        },
      ),
    );
  }
}
