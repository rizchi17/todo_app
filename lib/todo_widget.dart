import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todo_repository.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({super.key, required this.todo, required this.onUpdate});
  final Todo todo;
  final Function() onUpdate;

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  final TodoRepository _todoRepository = TodoRepository();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  await _todoRepository.deleteTodo(widget.todo.id);
                  widget.onUpdate();
                },
                icon: Icon(Icons.delete)),
            Text(widget.todo.text),
          ],
        ),
        Checkbox(
          value: widget.todo.done,
          onChanged: (bool? value) async {
            await _todoRepository.changeTodoStatus(widget.todo);
                  widget.onUpdate();
          },
        ),
      ],
    );
  }
}
