import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emission/home.dart';

void main() {
  testWidgets('Verify elements present on Home page',
      (WidgetTester tester) async {
    // Arrange - Pump Home widget to tester
    await tester.pumpWidget(MaterialApp(home: Home()));

    // Act - Find widgets by type or text
    var totalPointsText = find.text('Total Points');
    var circleAvatar = find.byType(CircleAvatar);

    // Additional debugging - Print the widget tree
    // This helps to see if the widget tree matches your expectations
    await tester.pumpAndSettle(); // Wait for any animations to complete
    debugDumpApp();

    // Assert - Check that widgets are present
    expect(totalPointsText, findsOneWidget);
    expect(circleAvatar, findsOneWidget);
  });
}
