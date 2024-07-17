import 'package:user_management_app_provider/data/repositories/user_repository.dart';
import 'package:user_management_app_provider/domain/entities/user.dart';

class FetchUsers {
  final UserRepository repository;

  FetchUsers({required this.repository});

  Future<List<User>> call() async {
    return await repository.fetchUsers();
  }
}

class UpdateUser {
  final UserRepository repository;

  UpdateUser({required this.repository});

  Future<void> call(User user) async {
    return await repository.updateUser(user);
  }
}
