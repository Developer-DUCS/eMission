/* import '../lib/api_service.dart';
import '../lib/home.dart';
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
    final apiService = new MockApiService();

    // Mock SharedPreferences
    final sharedPreferences = MockSharedPreferences();

    // Mock getUserID response
    when(sharedPreferences.getInt("userID")).thenReturn(1);

    // Mock getEarnedPoints response
    when(apiService.get('getEarnedPoints?userID=1')).thenAnswer(
      (_) async =>
          // error here
          ApiResponse(
        200,
        {
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
    await tester.pump(const Duration(seconds: 2));

    // Verify that the total points are displayed correctly
    expect(find.text('Total Points: 50'), findsOneWidget);

    verify(apiService.get('getEarnedPoints?userID=1')).called(1);
  });
}
 */