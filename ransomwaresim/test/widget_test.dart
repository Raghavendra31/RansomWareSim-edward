// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ransomwaresim/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SecuritySimApp());

    // Verify that the app starts with 'Idle' status
    expect(find.text('Status: Idle'), findsOneWidget);

    // Verify that we have defence options
    expect(find.text('Encryption'), findsOneWidget);
    expect(find.text('Back-Up'), findsOneWidget);
    expect(find.text('Fraud Link Detection'), findsOneWidget);
  });
}
