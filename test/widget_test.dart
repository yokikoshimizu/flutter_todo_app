import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart'; // 👈 ここで MyApp を読み込む

void main() {
  testWidgets('ToDo app smoke test', (WidgetTester tester) async {
    // アプリを起動
    await tester.pumpWidget(const MyApp());

    // 「ToDoリスト」という文字が1つだけ表示されていることを確認
    expect(find.text('ToDoリスト'), findsOneWidget);
  });
}