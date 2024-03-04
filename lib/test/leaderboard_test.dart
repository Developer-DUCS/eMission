import 'package:emission/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:emission/leaderboard.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  testWidgets('Verify Leaderboard UI elements', (WidgetTester tester) async {
    var expectedRankApiResponse = ApiResponse<List<Map<String, dynamic>>>(200, [
      {'leaderboard_rank': 42}
    ]);

    when(mockApiService.get("getUserRank?userID=0"))
        .thenAnswer((_) async => expectedRankApiResponse);

    var expectedApiResponse = new ApiResponse<List<Map<String, dynamic>>>(200, [
      {
        "userID": 92,
        "username": "amyiscool",
        "drive_points": 80,
        "challenge_points": 70,
        "total_points": 150
      },
      {
        "userID": 80,
        "username": "user",
        "drive_points": 0,
        "challenge_points": 115,
        "total_points": 115
      },
      {
        "userID": 76,
        "username": "check",
        "drive_points": 0,
        "challenge_points": 20,
        "total_points": 20
      }
    ]);
    print(expectedApiResponse.statusCode);
    print(expectedApiResponse.data);

    when(mockApiService.get("getTopTen"))
        .thenAnswer((_) async => expectedApiResponse);

    // Arrange - Pump Leaderboard widget to tester
    await tester.pumpWidget(
      MaterialApp(
        home: Leaderboard(apiService: mockApiService),
      ),
    );

    // Wait for the FutureBuilder to complete
    await tester.pumpAndSettle();

    var userRankText = find.text("Your Rank");
    var leaderboardText = find.text("Leaderboard");

    expect(userRankText, findsOneWidget);
    expect(leaderboardText, findsOneWidget);

    verify(mockApiService.get("getUserRank?userID=0")).called(1);
    verify(mockApiService.get("getTopTen")).called(1);
  });
}
