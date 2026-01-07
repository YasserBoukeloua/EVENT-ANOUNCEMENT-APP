import 'package:eventify/data/databases/db_notifications.dart';

class NotificationRepository {
  final DBNotificationsTable _dbNotifications = DBNotificationsTable();

  Future<int> createNotification({
    required int userId,
    required String type,
    required String title,
    required String message,
    int? relatedId,
    String? relatedType,
  }) async {
    return await _dbNotifications.insertRecordGetId({
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'related_id': relatedId,
      'related_type': relatedType,
      'is_read': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getNotificationsForUser(int userId) async {
    return await _dbNotifications.getNotificationsForUser(userId);
  }

  Future<int> getUnreadCount(int userId) async {
    return await _dbNotifications.getUnreadCount(userId);
  }

  Future<bool> markAsRead(int notificationId) async {
    return await _dbNotifications.markAsRead(notificationId);
  }

  Future<bool> markAllAsRead(int userId) async {
    return await _dbNotifications.markAllAsRead(userId);
  }

  Future<bool> deleteNotification(int notificationId) async {
    return await _dbNotifications.deleteRecord(notificationId);
  }
}
