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

  static String sql_repost_likes = '''
    CREATE TABLE IF NOT EXISTS repost_likes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      repost_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      FOREIGN KEY (repost_id) REFERENCES reposts (id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users (id),
      UNIQUE(repost_id, user_id)
    )
  ''';

  // Get reposts for a user by username
  Future<List<Map<String, dynamic>>> getRepostsByUsername(
    String username,
  ) async {
    try {
      final database = await DBHelper.getDatabase();

      // First get the user ID from username
      final userResults = await database.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
        limit: 1,
      );

      if (userResults.isEmpty) {
        return [];
      }

      final userId = userResults.first['id'];

      // Join with events to get event details
      final results = await database.rawQuery(
        '''
        SELECT 
          r.*,
          e.id as event_id,
          e.title as event_title,
          e.description as event_description,
          e.date as event_date,
          e.location as event_location,
          e.category as event_category,
          e.publisher as event_publisher,
          e.is_free as event_is_free,
          e.photo_path as event_photo_path,
          e.created_at as event_created_at
        FROM reposts r
        LEFT JOIN events e ON r.event_id = e.id
        WHERE r.user_id = ?
        ORDER BY r.created_at DESC
      ''',
        [userId],
      );

      return results;
    } catch (e, stacktrace) {
      print('Get reposts by username error: $e --> $stacktrace');
      return [];
    }
  }

  // Get repost count for a user by username
  Future<int> getRepostCountByUsername(String username) async {
    try {
      final database = await DBHelper.getDatabase();

      final userResults = await database.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
        limit: 1,
      );

      if (userResults.isEmpty) {
        return 0;
      }

      final userId = userResults.first['id'];

      final results = await database.query(
        db_table,
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      return results.length;
    } catch (e, stacktrace) {
      print('Get repost count error: $e --> $stacktrace');
      return 0;
    }
  }

  // Get repost by ID with full details
  Future<Map<String, dynamic>?> getRepostById(int repostId) async {
    try {
      final database = await DBHelper.getDatabase();

      final results = await database.rawQuery(
        '''
        SELECT 
          r.*,
          e.id as event_id,
          e.title as event_title,
          e.description as event_description,
          e.date as event_date,
          e.location as event_location,
          e.category as event_category,
          e.publisher as event_publisher,
          e.is_free as event_is_free,
          e.photo_path as event_photo_path,
          e.created_at as event_created_at,
          u.username as user_username,
          u.name as user_name,
          u.lastname as user_lastname,
          u.photo as user_photo
        FROM reposts r
        LEFT JOIN events e ON r.event_id = e.id
        LEFT JOIN users u ON r.user_id = u.id
        WHERE r.id = ?
      ''',
        [repostId],
      );

      if (results.isEmpty) {
        return null;
      }

      return results.first;
    } catch (e, stacktrace) {
      print('Get repost by ID error: $e --> $stacktrace');
      return null;
    }
  }

  // Get repost by user ID
  Future<List<Map<String, dynamic>>> getRepostsByUserId(int userId) async {
    try {
      final database = await DBHelper.getDatabase();

      // Join with events to get event details
      final results = await database.rawQuery(
        '''
        SELECT 
          r.*,
          e.id as event_id,
          e.title as event_title,
          e.description as event_description,
          e.date as event_date,
          e.location as event_location,
          e.category as event_category,
          e.publisher as event_publisher,
          e.is_free as event_is_free,
          e.photo_path as event_photo_path,
          e.created_at as event_created_at
        FROM reposts r
        LEFT JOIN events e ON r.event_id = e.id
        WHERE r.user_id = ?
        ORDER BY r.created_at DESC
      ''',
        [userId],
      );

      return results;
    } catch (e, stacktrace) {
      print('Get reposts by user ID error: $e --> $stacktrace');
      return [];
    }
  }

  // Get reposts for a user (by user ID)
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

  Future<int> getRepostLikeCount(int repostId) async {
    try {
      final database = await DBHelper.getDatabase();
      final results = await database.query(
        'repost_likes',
        where: 'repost_id = ?',
        whereArgs: [repostId],
      );
      return results.length;
    } catch (e) {
      print('Get repost like count error: $e');
      return 0;
    }
  }

  Future<bool> hasUserLikedRepost(int userId, int repostId) async {
    try {
      final database = await DBHelper.getDatabase();
      final results = await database.query(
        'repost_likes',
        where: 'user_id = ? AND repost_id = ?',
        whereArgs: [userId, repostId],
      );
      return results.isNotEmpty;
    } catch (e) {
      print('Check repost like error: $e');
      return false;
    }
  }

  Future<bool> toggleRepostLike(int userId, int repostId) async {
    try {
      final database = await DBHelper.getDatabase();
      
      // Check if already liked
      final hasLiked = await hasUserLikedRepost(userId, repostId);
      
      if (hasLiked) {
        // Unlike
        final count = await database.delete(
          'repost_likes',
          where: 'user_id = ? AND repost_id = ?',
          whereArgs: [userId, repostId],
        );
        return count > 0;
      } else {
        // Like
        final now = DateTime.now().toIso8601String();
        final id = await database.insert('repost_likes', {
          'repost_id': repostId,
          'user_id': userId,
          'created_at': now,
        });
        return id > 0;
      }
    } catch (e) {
      print('Toggle repost like error: $e');
      return false;
    }
  }
}
