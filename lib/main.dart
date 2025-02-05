import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todo_repository.dart';
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
  final TodoRepository _todoRepository = TodoRepository();
  List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        await fetchTodos();
      },
    );
  }

  Future<void> fetchTodos() async {
    final todos = await _todoRepository.getTodos();
    setState(() {
      _todos = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                        await _todoRepository.addTodo(_controller.text);
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
                        todo: _todos[index],
                        onUpdate: fetchTodos,
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
