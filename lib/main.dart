import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/todo_provider.dart';
import 'package:todo_app/todo_widget.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final asyncTodos = ref.watch(todoListProvider);
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
                    await ref.read(todoListProvider.notifier).fetchTodos();
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
                        await ref.read(todoListProvider.notifier).addTodo(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(
                        Icons.add_circle,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                switch (asyncTodos) {
                  AsyncData(:final value) => Expanded(
                      child: ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return TodoWidget(
                            todo: value[index],
                          );
                        },
                      ),
                    ),
                  AsyncError() => Text('Error'),
                  _ => const Center(child: CircularProgressIndicator()),
                }
              ],
            ),
          ),
        ));
  }
}
