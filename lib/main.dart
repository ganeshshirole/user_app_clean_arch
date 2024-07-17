import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_management_app_provider/data/repositories/user_repository.dart';
import 'package:user_management_app_provider/domain/usecases/fetch_users.dart';
import 'package:user_management_app_provider/presentation/providers/user_provider.dart';
import 'package:user_management_app_provider/presentation/screens/user_list_screen.dart';
import 'package:user_management_app_provider/utils/constants.dart';

void main() {
  final userRepository = UserRepository(baseUrl: API.baseUrl);
  final fetchUsers = FetchUsers(repository: userRepository);
  final updateUser = UpdateUser(repository: userRepository);

  runApp(MyApp(fetchUsers: fetchUsers, updateUser: updateUser));
}

class MyApp extends StatelessWidget {
  final FetchUsers fetchUsers;
  final UpdateUser updateUser;

  const MyApp({super.key, required this.fetchUsers, required this.updateUser});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          UserProvider(fetchUsers: fetchUsers, updateUser: updateUser)
            ..loadUsers(),
      child: MaterialApp(
        title: 'User Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const UserListScreen(),
      ),
    );
  }
}
