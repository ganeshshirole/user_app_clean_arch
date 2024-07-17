import 'package:user_management_app_provider/domain/entities/user.dart';

class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final AddressModel address;
  final CompanyModel company;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: AddressModel.fromJson(json['address']),
      company: CompanyModel.fromJson(json['company']),
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      username: username,
      email: email,
      phone: phone,
      website: website,
      address: address.toEntity(),
      company: company.toEntity(),
    );
  }
}

class AddressModel {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  AddressModel({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
    );
  }

  Address toEntity() {
    return Address(
      street: street,
      suite: suite,
      city: city,
      zipcode: zipcode,
    );
  }
}

class CompanyModel {
  final String name;
  final String catchPhrase;
  final String bs;

  CompanyModel({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }

  Company toEntity() {
    return Company(
      name: name,
      catchPhrase: catchPhrase,
      bs: bs,
    );
  }
}
