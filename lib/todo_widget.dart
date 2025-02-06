import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todo_provider.dart';

class TodoWidget extends ConsumerStatefulWidget {
  const TodoWidget({super.key, required this.todo});
  final Todo todo;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends ConsumerState<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  await ref.read(todoListProvider.notifier).deleteTodo(widget.todo.id);
                },
                icon: Icon(Icons.delete)),
            Text(widget.todo.text),
          ],
        ),
        Checkbox(
          value: widget.todo.done,
          onChanged: (bool? value) async {
            await ref.read(todoListProvider.notifier).toggleTodoStatus(widget.todo);
          },
        ),
      ],
    );
  }
}
