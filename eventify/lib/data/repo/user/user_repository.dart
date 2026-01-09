import 'package:eventify/models/user_model.dart';
import 'package:eventify/services/session_service.dart';
import 'package:eventify/services/api_service.dart';
import 'user_repo_abstract.dart';

class UserRepository extends UserRepositoryBase {
  final _apiService = ApiService();

  @override
  Future<User?> login(String email, String password) async {
    try {
      // Fetch all users and find matching credentials
      final users = await _apiService.getUsers();

      final userRecord = users.firstWhere(
        (user) => user['email'] == email,
        orElse: () => null,
      );

      if (userRecord == null) {
        return null;
      }

      // Save session
      await SessionService.saveUserId(userRecord['id']);

      return User.fromJson(userRecord);
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  @override
  Future<User?> signup(Map<String, dynamic> userData) async {
    try {
      // Create user via API
      final response = await _apiService.createUser(userData);

      if (response == null) {
        return null;
      }

      // Save session
      await SessionService.saveUserId(response['id']);

      return User.fromJson(response);
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  @override
  Future<User?> getUser(int id) async {
    try {
      final userRecord = await _apiService.getUser(id);

      if (userRecord == null) {
        return null;
      }

      return User.fromJson(userRecord);
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
      // TODO: Implement API update when endpoint is ready
      return false;
    } catch (e) {
      print('Update user error: $e');
      return false;
    }
  }
}
