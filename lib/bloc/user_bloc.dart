import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/bloc/user_event.dart';
import 'package:user_management_app/bloc/user_state.dart';
import 'package:user_management_app/models/user.dart';
import 'package:user_management_app/services/api_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;

  UserBloc({required this.apiService}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<UpdateUser>(_onUpdateUser);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await apiService.fetchUsers();
      emit(UserLoaded(users.map((user) => User.fromJson(user)).toList()));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await apiService.updateUser(event.user.id, {
        'name': event.name,
        'email': event.email,
        'phone': event.phone,
      });
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
