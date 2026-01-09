import 'package:sqflite/sqflite.dart';
import 'db_base.dart';
import 'dbhelper.dart';

class DBNotificationsTable extends DBBaseTable {
  @override
  var db_table = 'notifications';

  static String sql_code = '''
    CREATE TABLE notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      type TEXT NOT NULL,
      title TEXT NOT NULL,
      message TEXT NOT NULL,
      related_id INTEGER,
      related_type TEXT,
      is_read INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  Future<List<Map<String, dynamic>>> getNotificationsForUser(int userId) async {
    try {
      final database = await DBHelper.getDatabase();
      return await database.query(
        db_table,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  Future<int> getUnreadCount(int userId) async {
    try {
      final database = await DBHelper.getDatabase();
      final result = await database.rawQuery(
        'SELECT COUNT(*) as count FROM $db_table WHERE user_id = ? AND is_read = 0',
        [userId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  Future<bool> markAsRead(int notificationId) async {
    try {
      final database = await DBHelper.getDatabase();
      await database.update(
        db_table,
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );
      return true;
    } catch (e) {
      print('Error marking as read: $e');
      return false;
    }
  }

  Future<bool> markAllAsRead(int userId) async {
    try {
      final database = await DBHelper.getDatabase();
      await database.update(
        db_table,
        {'is_read': 1},
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      return true;
    } catch (e) {
      print('Error marking all as read: $e');
      return false;
    }
  }
}
