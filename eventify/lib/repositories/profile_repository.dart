import 'package:eventify/data/repo/user/user_repository.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/services/session_service.dart';

class ProfileRepository {
  final UserRepository _userRepository = UserRepository();
  User? _currentUser;

  Future<User?> getProfile() async {
    _currentUser = await _userRepository.getCurrentUser();
    return _currentUser;
  }

  Future<Map<String, int>> getUserStats() async {
    // In a real app, these would come from the database
    // For now, we'll return mock data or calculate what we can
    return {
      'events_attended': 12,
      'events_created': 5,
      'followers': 120,
      'following': 85,
    };
  }

  Future<User?> updateUsername(String username) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return null;

    final success = await _userRepository.updateUser(userId, {'username': username});
    if (success) {
      return await getProfile();
    }
    return _currentUser;
  }

  Future<User?> updateEmail(String email) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return null;

    final success = await _userRepository.updateUser(userId, {'email': email});
    if (success) {
      return await getProfile();
    }
    return _currentUser;
  }

  void clearUser() {
    _currentUser = null;
  }
}
