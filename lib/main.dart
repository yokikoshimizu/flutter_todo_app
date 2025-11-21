import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// アプリ全体のルートウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      home: const TodoPage(),
    );
  }
}

// Todo を表すデータクラス
class Todo {
  String title;
  bool isDone;

  // コンストラクタ
  Todo({
    required this.title, // 必須パラメータ
    this.isDone = false, // 省略時は未完了
  });
}

// ToDo 一覧画面（状態あり）
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // ToDo のリスト（文字列ではなく Todo 型）
  final List<Todo> _todos = [
    Todo(title: '牛乳を買う'),
    Todo(title: '返信する'),
    Todo(title: '勉強する'),
  ];

  // 入力用のコントローラ
  final TextEditingController _textController = TextEditingController();

  // 未完了タスクの件数を計算するゲッター
  int get _remainingCount =>
      _todos.where((todo) => !todo.isDone).length;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // タスク追加ダイアログ
  Future<void> _showAddTodoDialog() async {
    _textController.clear();

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
                // キャンセル（null）を返す
                Navigator.of(dialogContext).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                final text = _textController.text.trim();
                // 入力文字列を返す
                Navigator.of(dialogContext).pop(text);
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );

    if (newTodoTitle != null && newTodoTitle.isNotEmpty) {
      setState(() {
        // ここで Todo を 1 つ作ってリストに追加
        _todos.add(Todo(title: newTodoTitle));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          // タスクが0件なら EmptyView を表示
          child: _todos.isEmpty
              ? const _EmptyView()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 残りタスク件数のバー
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.list_alt_outlined),
                    const SizedBox(width: 8),
                    Text(
                      '未完了タスク：$_remainingCount件',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // リスト本体（スクロールさせるため Expanded で包む）
              Expanded(
                child: ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    final todo = _todos[index];

                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 4.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CheckboxListTile(
                          value: todo.isDone, // チェック状態
                          onChanged: (bool? value) {
                            setState(() {
                              // value が null のときは false を使う
                              todo.isDone = value ?? false;
                            });
                          },
                          title: Text(
                            todo.title,
                            style: todo.isDone
                                ? const TextStyle(
                              decoration:
                              TextDecoration.lineThrough,
                              // 取り消し線
                              color: Colors.grey,
                            )
                                : const TextStyle(
                              fontSize: 16,
                            ), // 未完了の時は普通のスタイル
                          ),
                          // 右側に削除ボタンをつける
                          secondary: IconButton(
                            tooltip: '削除',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() {
                                _todos.removeAt(index);
                              });
                            },
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoDialog,
        icon: const Icon(Icons.add),
        label: const Text('追加'),
      ),
    );
  }
}

// タスクが0件のときに表示するウィジェット
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'タスクはまだありません',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '右下の「追加」ボタンから\nタスクを登録してみましょう',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
