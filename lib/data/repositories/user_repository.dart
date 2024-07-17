import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user_management_app_provider/data/models/user_model.dart';
import 'package:user_management_app_provider/domain/entities/user.dart';
import 'package:user_management_app_provider/utils/constants.dart';

class UserRepository {
  final String baseUrl;
  final http.Client client;

  UserRepository({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<List<User>> fetchUsers() async {
    final response =
        await client.get(Uri.parse('$baseUrl/${APIEndpoints.users}'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<UserModel> userModels =
          jsonData.map((json) => UserModel.fromJson(json)).toList();
      final List<User> users =
          userModels.map((userModel) => userModel.toEntity()).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateUser(User user) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${APIEndpoints.users}/${user.id}'),
      headers: {Constants.contentType: Constants.contentTypeJson},
      body: json.encode({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }
}
