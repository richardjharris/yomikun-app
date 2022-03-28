import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';

void main() {
  testWidgets('placeholder message displayed', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: PlaceholderMessage("test_message")));
    final messageFinder = find.text("test_message");
    expect(messageFinder, findsOneWidget);
  });
}
