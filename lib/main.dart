import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//アプリ全体のルートウィジェット
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
class TodoPageState extends State<TodoPage> {
  final List<String> _todos = [
    '牛乳を買う',
    'メールを返信する',
    '勉強をする',
  ];

  //入力用のコントローラー
  final TextEditingController _textController = TextEditingController();

  //画面が破棄されるときに呼ばれるメソッド
  @override
  void dispose() {
    //コントローラーの後処理（メモリ開放）
    _textController.dispose();
    super.dispose();

    //タスク追加ダイアログを表示するメソッド
    Future<void> _showAddTodoDialog() async {
      //前の入力が入らないようにクリア
      _textController.clear();

      //showDialogはFuture（後で結果が帰ってくる『約束』）を返す
      final String? newTodoTitle = await showDialog<String>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('新しいタスク'),
              content: TextField(
                controller: _textController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '例：買い物に行く',
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      //何も返さずにダイアログを閉じる（キャンセル）
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('キャンセル'),
                ),
                TextButton(
                    onPressed: () {
                      final text = _textController.text.trim();
                      //入力された文字列をダイアログの戻り値として返す
                      Navigator.of(dialogContext).pop(text);
                    },
                    child: const Text('追加'),
                ),
              ],
            );
          },
      );

      //newTodoTitle が null でなく、かつ空文字でない場合だけ追加
      if (newTodoTitle != null && newTodoTitle.isNotEmpty) {
        setState(() {
          _todos.add(newTodoTitle);
        });
      }
    }

    @override
    Widget build (BuildContext context) {
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
            onPressed: _showAddTodoDialog,
            child: const Icon(Icons.add),
        ),
      );
    }
  }



