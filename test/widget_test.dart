import 'package:first_flutter_app/api_service.dart';
import 'package:first_flutter_app/home.dart'; // Import your Home widget
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

class MockApiService extends Mock implements ApiService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  testWidgets('Home Widget Test', (WidgetTester tester) async {
    // Mock ApiService
    final apiService = MockApiService();

    // Mock SharedPreferences
    final sharedPreferences = MockSharedPreferences();

    // Mock getUserID response
    when(sharedPreferences.getInt("userID")).thenReturn(1);

    // Mock getEarnedPoints response
    when(apiService.get('getEarnedPoints?userID=1')).thenAnswer(
      (_) async =>
          // error here
          Response(
        statusCode: 200,
        data: {
          'results': [
            {'total_points': 50}
          ]
        }, // Adjust as needed
      ),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Home(),
      ),
    );

    // Wait for the Future to complete
    await tester.pumpAndSettle();

    // Verify that the total points are displayed correctly
    expect(find.text('Total Points: 50'), findsOneWidget);

    // You can add more test cases based on your requirements
  });
}
