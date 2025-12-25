import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/auth_repository.dart';
import 'package:eventify/cubits/auth/signup/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(const SignupInitial());

  // Signup user
  Future<void> signup(Map<String, dynamic> userData) async {
    // Validate required fields
    if (userData['email'] == null || 
        userData['username'] == null ||
        userData['password'] == null) {
      emit(const SignupFailure('Please fill in all required fields'));
      return;
    }

    emit(const SignupLoading());

    try {
      final user = await _authRepository.signup(userData);
      
      if (user == null) {
        emit(const SignupFailure('Failed to create account'));
        return;
      }
      
      emit(SignupSuccess(user));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  // Reset to initial state
  void reset() {
    emit(const SignupInitial());
  }
}
