import 'package:flutter_test/flutter_test.dart';
import 'package:app_terjemahan/main.dart';

void main() {
  testWidgets('Aplikasi terjemahan smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
