import 'package:eventify/models/user_model.dart';
import 'package:eventify/services/session_service.dart';
import 'package:eventify/services/api_service.dart';
import 'user_repo_abstract.dart';

class UserRepository extends UserRepositoryBase {
  final _apiService = ApiService();

  @override
  Future<User?> login(String email, String password) async {
    try {
      final response = await _apiService.loginUser(email, password);

      if (response == null) {
        return null;
      }

      final user = User.fromJson(response);

      // Save session
      await SessionService.saveUserId(user.id);

      return user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  @override
  Future<User?> signup(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.signupUser(userData);

      if (response == null) {
        return null;
      }

      final user = User.fromJson(response);

      // Save session
      await SessionService.saveUserId(user.id);

      return user;
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  @override
  Future<User?> getUser(int id) async {
    try {
      final response = await _apiService.getUser(id);

      if (response == null) {
        return null;
      }

      return User.fromJson(response);
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userId = await SessionService.getUserId();

      if (userId == null) {
        return null;
      }

      return await getUser(userId);
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  @override
  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    try {
      await _apiService.updateUser(id, data);
      return true;
    } catch (e) {
      print('Update user error: $e');
      return false;
    }
  }
}
