import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layout.dart';
import '../settings.dart';
import '../leaderboard.dart';
import '../api_service.dart';
import 'package:mockito/mockito.dart';
import '../drive-button.dart';
import '../create-account.dart';
import 'package:http/http.dart' as http;
import '../login.dart';
import '../home.dart';
import '../vehicles.dart';
import '../manual.dart';

class MockApiService extends Mock implements ApiService {}

class MockClient extends Mock implements http.Client {}

void main() {
  group('Layout Widget Tests', () {
    testWidgets('Layout widget test', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Container(),
            appBar: true,
            bottomBar: true,
            driveButton: true,
          ),
        ),
      );

      // Verify elements on the page
      expect(find.text('eMission'), findsOneWidget);
      expect(find.byIcon(Icons.directions_car), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Layout switches to Settings', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Container(),
            appBar: true,
            bottomBar: true,
            driveButton: true,
          ),
          routes: {
            'settings': (context) => const Layout(
                  body: Settings(),
                  pageIndex: 2,
                  driveButton: false,
                ),
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Support'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    /* testWidgets('Drive button navigates to next page',
      (WidgetTester tester) async {
    final MockApiService mockApiService = MockApiService();

    await tester.pumpWidget(
      MaterialApp(
        home: ButtonPage(apiService: mockApiService),
        routes: {
          'carbon_report': (context) => Container(),
        },
      ),
    );

    await tester.tap(find.byType(RawMaterialButton));

    await tester.pumpAndSettle();

    expect(find.byType(Container), findsOneWidget);
  }); */

    testWidgets('Layout switches to Leaderboard', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Container(),
            appBar: true,
            bottomBar: true,
            driveButton: true,
          ),
          routes: {
            '/': (context) => Layout(
                  body: Container(),
                  appBar: true,
                  bottomBar: true,
                  driveButton: true,
                ),
            'leaderboard': (context) => Layout(
                  body: Leaderboard(apiService: ApiService()),
                  pageIndex: 1,
                  driveButton: false,
                ),
          },
        ),
      );

      await tester.tap(find.byType(BottomNavigationBar).first);

      await tester.pumpAndSettle();

      expect(find.text('Leaderboard'), findsOneWidget);
    });
    testWidgets('Layout switches to Drive Button Page',
        (WidgetTester tester) async {
      final apiService = MockApiService();

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Container(),
            appBar: true,
            bottomBar: true,
            driveButton: true,
          ),
          routes: {
            'button-page': (context) => ButtonPage(apiService: apiService),
          },
        ),
      );

      expect(find.byType(Layout), findsOneWidget);

      await tester.tap(find.byIcon(Icons.directions_car));
      await tester.pumpAndSettle();

      expect(find.byType(ButtonPage), findsOneWidget);
    });
  });

  group('CreateAccount Widget Tests', () {
    testWidgets('Layout and initial state', (WidgetTester tester) async {
      final apiService = MockApiService();

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: CreateAccount(),
            appBar: false,
            bottomBar: false,
            driveButton: false,
          ),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Submitting form with valid data', (WidgetTester tester) async {
      final apiService = MockApiService();

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: CreateAccount(),
            appBar: false,
            bottomBar: false,
            driveButton: false,
          ),
        ),
      );

      await tester.enterText(find.byKey(Key('email')), 'test@example.com');
      await tester.enterText(find.byKey(Key('username')), 'testuser');
      await tester.enterText(find.byKey(Key('displayName')), 'Test User');
      await tester.enterText(find.byKey(Key('password')), 'password');
      await tester.enterText(find.byKey(Key('confirmPassword')), 'password');

      await tester.tap(find.text('Create'));

      await tester.pump();

      //expect(find.text('Error'), findsNothing);
    });
  });

  group('Drive Button Tests', () {
    testWidgets('Drive button navigates to next page',
        (WidgetTester tester) async {
      final MockApiService mockApiService = MockApiService();

      await tester.pumpWidget(
        MaterialApp(
          home: ButtonPage(apiService: mockApiService),
          routes: {
            'carbon_report': (context) => Container(),
          },
        ),
      );

      await tester.tap(find.byType(RawMaterialButton));

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('Login Widget Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    testWidgets('Login form submission test', (WidgetTester tester) async {
      final int mockStatusCode = 200;
      final Map<String, dynamic> mockResponseData = {
        "userID": 123,
        "email": "test@example.com",
        "userName": "testuser",
        "displayName": "Test User"
      };
      when(mockApiService.post('authUser', {
        'email': 'test@example.com',
        'password': 'password',
      })).thenAnswer(
        (_) => Future.value(ApiResponse(mockStatusCode, mockResponseData)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Login(),
            appBar: false,
            bottomBar: false,
            driveButton: false,
          ),
        ),
      );

      await tester.enterText(
          find.byKey(const Key('email')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password')), 'password');

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('Login form submission with invalid credentials test',
        (WidgetTester tester) async {
      final int mockStatusCode = 401;

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Login(),
            appBar: false,
            bottomBar: false,
            driveButton: false,
          ),
        ),
      );
      await tester.enterText(
          find.byKey(const Key('email')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password')), 'password');

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('The username and/or password are not correct.'),
          findsOneWidget);
    });
  });
  group('Manual Widget Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    testWidgets('Widget initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Manual(apiService: mockApiService),
      ));

      expect(find.byType(DropdownButton<Map<String, dynamic>>), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
  group('Vehicle page tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    testWidgets('Vehicles widget displays vehicles correctly',
        (WidgetTester tester) async {
      final List<Map<String, dynamic>> mockVehicles = [
        {
          'carID': 1,
          'carName': 'Car 1',
          'year': 2020,
          'make': 'Make 1',
          'model': 'Model 1'
        },
        {
          'carID': 2,
          'carName': 'Car 2',
          'year': 2021,
          'make': 'Make 2',
          'model': 'Model 2'
        },
      ];

      when(mockApiService.get('vehicles?owner=123'))
          .thenAnswer((_) async => ApiResponse(200, mockVehicles));

      await tester.pumpWidget(MaterialApp(
        home: Vehicles(apiService: mockApiService),
      ));

      expect(find.text('Car 1'), findsOneWidget);
      expect(find.text('Car 2'), findsOneWidget);
    });
  });
  group('Home Widget Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Displays total points correctly', (WidgetTester tester) async {
      when(mockApiService.get('getEarnedPoints?userID=123'))
          .thenAnswer((_) async => ApiResponse(200, {
                'results': [
                  {'total_points': 100}
                ]
              }));

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Container(),
            appBar: true,
            bottomBar: true,
            driveButton: true,
          ),
          routes: {
            'home': (context) =>
                const Layout(body: Home(), pageIndex: 1, driveButton: true),
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Total Points: 100'), findsOneWidget);
    });

    testWidgets('Displays default profile name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Home(),
            appBar: true,
            bottomBar: true,
            driveButton: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your Name'), findsOneWidget);
    });

    testWidgets('Displays user profile name', (WidgetTester tester) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', 'John Doe');

      await tester.pumpWidget(
        MaterialApp(
          home: Layout(
            body: Home(),
            appBar: true,
            bottomBar: true,
            driveButton: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
