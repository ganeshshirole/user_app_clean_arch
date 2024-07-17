import 'package:equatable/equatable.dart';
import 'package:user_management_app/models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {}

class UpdateUser extends UserEvent {
  final User user;
  final String name;
  final String email;
  final String phone;

  const UpdateUser(this.user, this.name, this.email, this.phone);

  @override
  List<Object?> get props => [user, name, email, phone];
}
