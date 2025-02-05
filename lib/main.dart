import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todo_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();
  final dio = Dio();

  Future<void> fetchTodos() async {
    // GET
    final response = await dio.get('http://localhost:8080/todos');
    List<dynamic> jsonData = json.decode(response.data);
    List<Todo> todos = jsonData.map((data) => Todo.fromJson(data)).toList();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> addTodo(String text) async {
    // POST
    final data = {'text': text};
    await dio.post('http://localhost:8080/todos', data: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await fetchTodos();
                  },
                  icon: Icon(Icons.refresh),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Todoを入力',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await addTodo(_controller.text);
                        _controller.clear();

                        await fetchTodos();
                      },
                      icon: Icon(
                        Icons.add_circle,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return TodoWidget(
                        text: _todos[index].text,
                        done: _todos[index].done,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
