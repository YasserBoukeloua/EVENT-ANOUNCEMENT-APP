import 'package:eventify/data/repo/user/user_repository.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/services/session_service.dart';

class AuthRepository {
  final UserRepository _userRepository = UserRepository();

  Future<User?> login(String email, String password) async {
    return await _userRepository.login(email, password);
  }

  Future<User?> signup(Map<String, dynamic> userData) async {
    return await _userRepository.signup(userData);
  }

  Future<void> logout() async {
    await SessionService.clearSession();
  }
}
