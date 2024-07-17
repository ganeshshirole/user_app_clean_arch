import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:user_management_app_provider/domain/usecases/fetch_users.dart';
import 'package:user_management_app_provider/presentation/providers/user_provider.dart';
import 'package:user_management_app_provider/presentation/screens/user_list_screen.dart';
import 'package:user_management_app_provider/domain/entities/user.dart';

// A mock UserProvider with hardcoded values
class MockUserProvider extends ChangeNotifier implements UserProvider {
  final List<User> _users = [
    User(
      id: 1,
      name: 'Leanne Graham',
      username: 'Bret',
      email: 'Sincere@april.biz',
      phone: '1-770-736-8031 x56442',
      website: 'hildegard.org',
      address: Address(
        street: 'Kulas Light',
        suite: 'Apt. 556',
        city: 'Gwenborough',
        zipcode: '92998-3874',
      ),
      company: Company(
        name: 'Romaguera-Crona',
        catchPhrase: 'Multi-layered client-server neural-net',
        bs: 'harness real-time e-markets',
      ),
    ),
  ];

  bool _isLoading = false;

  String? _errorMessage;

  @override
  List<User> get users => _users;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  Future<void> loadUsers() async {
    // No-op for mock
  }

  @override
  Future<void> updateUserDetails(User user) async {
    // No-op for mock
  }

  @override
  FetchUsers get fetchUsers => throw UnimplementedError();

  @override
  UpdateUser get updateUser => throw UnimplementedError();
}

void main() {
  group('UserListScreen', () {
    late MockUserProvider mockUserProvider;

    setUp(() {
      mockUserProvider = MockUserProvider();
    });

    testWidgets('displays a list of users', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>.value(
          value: mockUserProvider,
          child: const MaterialApp(home: UserListScreen()),
        ),
      );

      await tester.pumpAndSettle(); // Finish loading

      expect(find.text('Users'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Leanne Graham'), findsOneWidget);
      expect(find.text('Sincere@april.biz'), findsOneWidget);
    });

    testWidgets('displays a loading indicator when loading', (WidgetTester tester) async {
      mockUserProvider._isLoading = true;
      mockUserProvider.notifyListeners();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>.value(
          value: mockUserProvider,
          child: const MaterialApp(home: UserListScreen()),
        ),
      );

      await tester.pump(); // Start loading

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays an error message on failure', (WidgetTester tester) async {
      mockUserProvider._errorMessage = 'Failed to load users';
      mockUserProvider.notifyListeners();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>.value(
          value: mockUserProvider,
          child: const MaterialApp(home: UserListScreen()),
        ),
      );

      await tester.pumpAndSettle(); // Finish loading

      expect(find.text('Failed to load users'), findsOneWidget);
    });
  });
}
