import 'package:flutter_test/flutter_test.dart';
import 'package:user_management_app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  test('fetchUsers returns a list of users', () async {
    final apiService = ApiService();
    final mockClient = MockClient((request) async {
      return http.Response(
        json.encode([
          {'id': 1, 'name': 'User 1', 'email': 'user1@example.com'},
        ]),
        200,
      );
    });
    final users = await apiService.fetchUsers();
    expect(users.length, 10);
    expect(users[0]['name'], 'Leanne Graham');
  });
}
