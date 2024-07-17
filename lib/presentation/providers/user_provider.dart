import 'package:flutter/material.dart';
import 'package:user_management_app_provider/domain/entities/user.dart';
import 'package:user_management_app_provider/domain/usecases/fetch_users.dart';

class UserProvider with ChangeNotifier {
  final FetchUsers fetchUsers;
  final UpdateUser updateUser;

  UserProvider({required this.fetchUsers, required this.updateUser});

  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => _users;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await fetchUsers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserDetails(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await updateUser(user);
      await loadUsers();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
