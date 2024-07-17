import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/bloc/user_bloc.dart';
import 'package:user_management_app/bloc/user_state.dart';
import 'package:user_management_app/models/user.dart';
import 'package:user_management_app/screens/user_list_screen.dart';
import 'package:user_management_app/services/api_service.dart';

void main() {
  testWidgets('User list screen shows users', (WidgetTester tester) async {
    // Mock API Service and User Repository
    final apiService = ApiService();
    final userBloc = UserBloc(apiService: apiService);
    // final fetchUsers = FetchUsers();

    await tester.pumpWidget(
      BlocProvider<UserBloc>(
        create: (_) => userBloc,
        child: const MaterialApp(home: UserListScreen()),
      ),
    );

    // Create UserBloc and emit a UserLoaded state
    userBloc.emit(UserLoaded([
      User(id: 1, name: 'Leanne Graham', email: 'Sincere@april.biz', phone: '1-770-736-8031 x56442', address: 'Address 1', company: 'Company 1'),
    ]));


    await tester.pump();

    expect(find.text('Leanne Graham'), findsOneWidget);
  });
}
