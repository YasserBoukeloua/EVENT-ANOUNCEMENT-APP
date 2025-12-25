import 'package:eventify/models/user_model.dart';
import 'user_repository.dart';

abstract class UserRepositoryBase {
  Future<User?> login(String email, String password);
  Future<User?> signup(Map<String, dynamic> userData);
  Future<User?> getUser(int id);
  Future<User?> getCurrentUser();
  Future<bool> updateUser(int id, Map<String, dynamic> data);

  static UserRepositoryBase? _instance;

  static UserRepositoryBase getInstance() {
    _instance ??= UserRepository();
    return _instance!;
  }
}
