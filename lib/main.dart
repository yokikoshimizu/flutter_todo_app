import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const TodoPage(),
    );
  }
}

//ToDo画面一覧
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

//ダミーのToDo
class _TodoPageState extends State<TodoPage> {
  final List<String> _todos = [
    '牛乳を買う',
    'メールを返信する',
    '勉強をする',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
      ),
      body: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            final todo = _todos[index];
            return ListTile(
              leading: const Icon(Icons.check_box_outline_blank),
              title: Text(todo),
            );
          },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 次のステップで「追加ダイアログ」を実装します
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ここからタスク追加を作っていきます')),
            );
          },
          child: const Icon(Icons.add),
          ),
    );
  }
}

