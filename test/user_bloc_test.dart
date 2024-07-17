import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:user_management_app/bloc/user_bloc.dart';
import 'package:user_management_app/bloc/user_event.dart';
import 'package:user_management_app/bloc/user_state.dart';
import 'package:user_management_app/models/user.dart';
import 'package:user_management_app/services/api_service.dart';

// Mock class for ApiService
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late UserBloc userBloc;

  setUp(() {
    mockApiService = MockApiService();
    userBloc = UserBloc(apiService: mockApiService);
  });

  tearDown(() {
    userBloc.close();
  });

  group('UserBloc', () {
    final user = User(
      id: 1,
      name: 'User 1',
      email: 'user1@example.com',
      phone: '1234567890',
      address: '123 Main St, Anytown',
      company: 'Acme Corp',
    );

    final List<User> users = [user];

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserLoaded] when FetchUsersEvent is added',
      build: () {
        when(mockApiService.fetchUsers()).thenAnswer((_) async => users);
        return userBloc;
      },
      act: (bloc) => bloc.add(FetchUsers()),
      expect: () => [UserLoading(), UserLoaded(users)],
      verify: (_) {
        verify(mockApiService.fetchUsers()).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserError] when FetchUsersEvent fails',
      build: () {
        when(mockApiService.fetchUsers()).thenThrow(Exception('Failed to fetch users'));
        return userBloc;
      },
      act: (bloc) => bloc.add(FetchUsers()),
      expect: () => [UserLoading(), const UserError('Exception: Failed to fetch users')],
      verify: (_) {
        verify(mockApiService.fetchUsers()).called(1);
      },
    );
  });
}
