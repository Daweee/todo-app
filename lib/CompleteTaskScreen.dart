// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'completed_todo_provider.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completedTodoProvider = Provider.of<CompletedTodoProvider>(context);
    final completedTasks = completedTodoProvider.completedTodos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
        backgroundColor: Color(0XFF0f1417),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: ListView.builder(
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];
            return Card(
              elevation: 5.0,
              color: Colors.grey[850],
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: ListTile(
                title: Text(
                  task.task,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: task.completed ? TextDecoration.none : null,
                  ),
                ),
                subtitle: Text(
                  task.details,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    decoration: task.completed ? TextDecoration.none : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
