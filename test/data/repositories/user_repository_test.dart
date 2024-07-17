import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:user_management_app_provider/data/repositories/user_repository.dart';
import 'package:user_management_app_provider/domain/entities/user.dart';

void main() {
  late UserRepository userRepository;
  late UserRepository userRepository404;

  setUp(() {
    userRepository =
        UserRepository(baseUrl: 'https://jsonplaceholder.typicode.com');
    userRepository404 =
        UserRepository(baseUrl: 'https://jsonplaceholder.typicode.co');
  });

  group('fetchUsers', () {
    test(
        'fetchUsers returns a list of users if the API call completes successfully',
        () async {
      final users = await userRepository.fetchUsers();

      expect(users.length,
          greaterThan(0)); // Assuming there are users in the API response
      expect(users[0], isA<User>());
      expect(users[0].address, isA<Address>());
      expect(users[0].company, isA<Company>());
    });

    test('fetchUsers throws exception on 404 error', () async {
      // Mocking a 404 response
      userRepository =
          UserRepository(baseUrl: 'https://jsonplaceholder.typicode.com/404');

      try {
        await userRepository.fetchUsers();
      } catch (e) {
        expect(e, isException); // Verify that an exception is thrown
        return;
      }
      fail(
          'Expected an exception to be thrown.'); // Fail the test if no exception is thrown
    });

    // Add more tests for error handling, edge cases, etc.
  });

  group('updateUser', () {
    test('updateUser updates a user successfully', () async {
      final userToUpdate = User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        address: Address(
          street: "Kulas Light",
          suite: "Apt. 556",
          city: "Gwenborough",
          zipcode: "92998-3874",
        ),
        company: Company(
          name: "Romaguera-Crona",
          catchPhrase: "Multi-layered client-server neural-net",
          bs: "harness real-time e-markets",
        ),
      );

      await userRepository.updateUser(userToUpdate);

      // Retrieve the updated user from the API
      final updatedUser = await _fetchUserById(userToUpdate.id);

      // Verify the updated user's state
      expect(updatedUser.id, userToUpdate.id);
      expect(updatedUser.name, userToUpdate.name);
      expect(updatedUser.username, userToUpdate.username);
      expect(updatedUser.email, userToUpdate.email);
      expect(updatedUser.phone, userToUpdate.phone);
      expect(updatedUser.website, userToUpdate.website);
      expect(updatedUser.address.street, userToUpdate.address.street);
      expect(updatedUser.address.suite, userToUpdate.address.suite);
      expect(updatedUser.address.city, userToUpdate.address.city);
      expect(updatedUser.address.zipcode, userToUpdate.address.zipcode);
      expect(updatedUser.company.name, userToUpdate.company.name);
      expect(updatedUser.company.catchPhrase, userToUpdate.company.catchPhrase);
      expect(updatedUser.company.bs, userToUpdate.company.bs);
    });

    test('updateUser throws exception on 404 error', () async {
      final userToUpdate = User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        address: Address(
          street: "Kulas Light",
          suite: "Apt. 556",
          city: "Gwenborough",
          zipcode: "92998-3874",
        ),
        company: Company(
          name: "Romaguera-Crona",
          catchPhrase: "Multi-layered client-server neural-net",
          bs: "harness real-time e-markets",
        ),
      );

      try {
        await userRepository404.updateUser(userToUpdate);
      } catch (e) {
        expect(e, isException); // Verify that an exception is thrown
        return;
      }
      fail(
          'Expected an exception to be thrown.'); // Fail the test if no exception is thrown
    });

    // Add more tests for error handling, edge cases, etc.
  });
}

/// Helper function to fetch user details by ID from the API
Future<User> _fetchUserById(int userId) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return User(
      id: jsonData['id'],
      name: jsonData['name'],
      username: jsonData['username'],
      email: jsonData['email'],
      phone: jsonData['phone'],
      website: jsonData['website'],
      address: Address(
        street: jsonData['address']['street'],
        suite: jsonData['address']['suite'],
        city: jsonData['address']['city'],
        zipcode: jsonData['address']['zipcode'],
      ),
      company: Company(
        name: jsonData['company']['name'],
        catchPhrase: jsonData['company']['catchPhrase'],
        bs: jsonData['company']['bs'],
      ),
    );
  } else {
    throw Exception('Failed to fetch user details');
  }
}
