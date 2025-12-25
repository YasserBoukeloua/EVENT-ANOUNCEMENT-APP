import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/auth_repository.dart';
import 'package:eventify/cubits/auth/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  bool rememberMe = false;

  LoginCubit(this._authRepository) : super(const LoginInitial());

  // Login user
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginFailure('Please enter email and password'));
      return;
    }

    emit(const LoginLoading());

    try {
      final user = await _authRepository.login(email, password);
      
      if (user == null) {
        emit(const LoginFailure('Invalid email or password'));
        return;
      }
      
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  // Toggle remember me
  void toggleRememberMe(bool value) {
    rememberMe = value;
  }

  // Reset to initial state
  void reset() {
    emit(const LoginInitial());
  }
}
