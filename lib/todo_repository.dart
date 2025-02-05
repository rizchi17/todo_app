import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:todo_app/todo.dart';

class TodoRepository {
  final dio = Dio();

  Future<List<Todo>> getTodos() async {
    // GET
    final response = await dio.get('http://localhost:8080/todos');
    List<dynamic> jsonData = json.decode(response.data);
    List<Todo> todos = jsonData.map((data) => Todo.fromJson(data)).toList();
    return todos;
  }

  Future<void> addTodo(String text) async {
    // POST
    final data = {'text': text};
    await dio.post('http://localhost:8080/todos', data: data);
  }

  Future<void> changeTodoStatus(Todo todo) async {
    // PUT
    final data = {'text': todo.text, 'done': !todo.done};
    final id = todo.id;
    await dio.put('http://localhost:8080/todos/$id', data: data);
  }

  Future<void> deleteTodo(int id) async {
    // DELETE
    await dio.delete('http://localhost:8080/todos/$id');
  }
}
