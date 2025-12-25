import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUserId = 'current_user_id';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Save logged-in user ID
  static Future<bool> saveUserId(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyUserId, userId);
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    } catch (e) {
      print('Error saving user ID: $e');
      return false;
    }
  }

  // Get current logged-in user ID
  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyUserId);
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Clear session (logout)
  static Future<bool> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserId);
      await prefs.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      print('Error clearing session: $e');
      return false;
    }
  }
}
