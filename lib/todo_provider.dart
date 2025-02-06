import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todo_repository.dart';

part 'todo_provider.g.dart';

@riverpod
TodoRepository todoRepository(Ref ref) => TodoRepository();

@riverpod
class TodoList extends _$TodoList {
  late final TodoRepository _repository;

  @override
  Future<List<Todo>> build() async {
    _repository = ref.read(todoRepositoryProvider);
    return await _repository.getTodos();
  }

  Future<void> addTodo(String text) async {
    await _repository.addTodo(text);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTodos());
  }

  Future<void> fetchTodos() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTodos());
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    await _repository.changeTodoStatus(todo);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTodos());
  }

  Future<void> deleteTodo(int id) async {
    await _repository.deleteTodo(id);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTodos());
  }
}
