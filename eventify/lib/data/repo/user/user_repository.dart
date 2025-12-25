import 'package:eventify/models/user_model.dart';
import 'package:eventify/services/session_service.dart';
import 'package:eventify/data/databases/db_users.dart';
import 'user_repo_abstract.dart';

class UserRepository extends UserRepositoryBase {
  final _dbUsers = DBUsersTable();

  @override
  Future<User?> login(String email, String password) async {
    try {
      final database = await _dbUsers.getRecords();
      
      // Find user with matching email and password
      final userRecord = database.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (userRecord.isEmpty) {
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
      // Add created_at timestamp
      userData['created_at'] = DateTime.now().toIso8601String();
      userData['is_certified'] = 0; // New users are not certified by default

      // Insert user
      final success = await _dbUsers.insertRecord(userData);
      
      if (!success) {
        return null;
      }

      // Get the newly created user
      final records = await _dbUsers.getRecords();
      if (records.isEmpty) {
        return null;
      }

      final newUser = records.first;
      
      // Save session
      await SessionService.saveUserId(newUser['id']);

      return User.fromJson(newUser);
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  @override
  Future<User?> getUser(int id) async {
    try {
      final userRecord = await _dbUsers.getRecordById(id);
      
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
      return await _dbUsers.updateRecord(id, data);
    } catch (e) {
      print('Update user error: $e');
      return false;
    }
  }
}
