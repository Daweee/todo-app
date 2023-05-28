class Todo {
  int id;
  String task;
  String details;
  bool completed;

  Todo({
    required this.id,
    required this.task,
    required this.details,
    this.completed = false,
  });
}
