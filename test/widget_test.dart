import 'package:flutter_test/flutter_test.dart';
import 'package:fitness/main.dart';

void main() {
  testWidgets('FitnessApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessApp());
    expect(find.text('SESSIONS'), findsOneWidget);
  });
}
