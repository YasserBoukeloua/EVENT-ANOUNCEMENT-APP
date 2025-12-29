import 'package:sqflite/sqflite.dart';

import 'db_base.dart';
import 'dbhelper.dart';

class DBEventsTable extends DBBaseTable {
  @override
  var db_table = 'events';

  static String sql_code = '''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      date TEXT,
      location TEXT,
      category TEXT,
      publisher TEXT,
      is_free INTEGER DEFAULT 1,
      photo_path TEXT,
      created_at TEXT
    )
  ''';

  // Get events by publisher username, sorted by date (newest first)
  Future<List<Map<String, dynamic>>> getEventsByPublisher(
    String publisherUsername,
  ) async {
    try {
      final database = await DBHelper.getDatabase();
      final results = await database.query(
        db_table,
        where: 'publisher = ?',
        whereArgs: [publisherUsername],
        orderBy: 'date DESC, created_at DESC',
      );
      return results;
    } catch (e, stacktrace) {
      print('Get events by publisher error: $e --> $stacktrace');
      return [];
    }
  }

  // Get events by publisher ID (for backend integration if needed)
  Future<List<Map<String, dynamic>>> getEventsByPublisherId(
    int publisherId,
  ) async {
    try {
      final database = await DBHelper.getDatabase();
      // Join with users table to get publisher info
      final results = await database.rawQuery(
        '''
        SELECT e.* FROM $db_table e
        LEFT JOIN users u ON e.publisher = u.username
        WHERE u.id = ?
        ORDER BY e.date DESC, e.created_at DESC
        ''',
        [publisherId],
      );
      return results;
    } catch (e, stacktrace) {
      print('Get events by publisher ID error: $e --> $stacktrace');
      return [];
    }
  }
}
