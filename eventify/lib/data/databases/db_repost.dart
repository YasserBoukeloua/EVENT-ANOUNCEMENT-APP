import 'package:eventify/data/databases/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'db_base.dart';

class DBRepostsTable extends DBBaseTable {
  @override
  var db_table = 'reposts';

  static String sql_code = '''
    CREATE TABLE reposts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      event_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      caption TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (event_id) REFERENCES events (id),
      FOREIGN KEY (user_id) REFERENCES users (id),
      UNIQUE(user_id, event_id)
    )
  ''';

  // Get reposts for a user
  Future<List<Map<String, dynamic>>> getRepostsByUser(int userId) async {
    try {
      final database = await DBHelper.getDatabase();

      // Join with events to get event details
      final results = await database.rawQuery(
        '''
        SELECT 
          r.*,
          e.title as event_title,
          e.description as event_description,
          e.date as event_date,
          e.location as event_location,
          e.category as event_category,
          e.publisher as event_publisher,
          e.is_free as event_is_free,
          e.photo_path as event_photo_path
        FROM reposts r
        LEFT JOIN events e ON r.event_id = e.id
        WHERE r.user_id = ?
        ORDER BY r.created_at DESC
      ''',
        [userId],
      );

      return results;
    } catch (e, stacktrace) {
      print('Get reposts by user error: $e --> $stacktrace');
      return [];
    }
  }

  // Get all reposts (for feed) with user info
  Future<List<Map<String, dynamic>>> getAllReposts() async {
    try {
      final database = await DBHelper.getDatabase();

      final results = await database.rawQuery('''
      SELECT 
        r.*,
        e.title as event_title,
        e.description as event_description,
        e.date as event_date,
        e.location as event_location,
        e.category as event_category,
        e.publisher as event_publisher,
        e.is_free as event_is_free,
        e.photo_path as event_photo_path,
        u.username as user_username,
        u.name as user_name,
        u.lastname as user_lastname,
        u.photo as user_photo
      FROM reposts r
      LEFT JOIN events e ON r.event_id = e.id
      LEFT JOIN users u ON r.user_id = u.id
      ORDER BY r.created_at DESC
    ''');

      return results;
    } catch (e, stacktrace) {
      print('Get all reposts error: $e --> $stacktrace');
      return [];
    }
  }

  // Check if user has reposted an event
  Future<bool> hasReposted(int userId, int eventId) async {
    try {
      final database = await DBHelper.getDatabase();

      final results = await database.query(
        db_table,
        where: 'user_id = ? AND event_id = ?',
        whereArgs: [userId, eventId],
      );

      return results.isNotEmpty;
    } catch (e, stacktrace) {
      print('Check repost error: $e --> $stacktrace');
      return false;
    }
  }

  // Remove repost
  Future<bool> removeRepost(int userId, int eventId) async {
    try {
      final database = await DBHelper.getDatabase();

      final count = await database.delete(
        db_table,
        where: 'user_id = ? AND event_id = ?',
        whereArgs: [userId, eventId],
      );

      return count > 0;
    } catch (e, stacktrace) {
      print('Remove repost error: $e --> $stacktrace');
      return false;
    }
  }
}
