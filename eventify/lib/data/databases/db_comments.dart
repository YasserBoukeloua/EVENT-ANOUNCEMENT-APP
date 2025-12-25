import 'db_base.dart';
import 'dbhelper.dart';

class DBCommentsTable extends DBBaseTable {
  @override
  var db_table = 'comments';
  
  static String sql_code = '''
    CREATE TABLE comments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      event_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      username TEXT NOT NULL,
      comment TEXT NOT NULL,
      is_liked INTEGER DEFAULT 0,
      created_at TEXT,
      FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';

  // Get comments for a specific event
  Future<List<Map<String, dynamic>>> getCommentsByEventId(int eventId) async {
    final db = await DBHelper.getDatabase();
    return await db.query(
      db_table,
      where: 'event_id = ?',
      whereArgs: [eventId],
      orderBy: 'created_at DESC',
    );
  }

  // Add a comment
  Future<int> addComment({
    required int eventId,
    required int userId,
    required String username,
    required String comment,
  }) async {
    final db = await DBHelper.getDatabase();
    return await db.insert(db_table, {
      'event_id': eventId,
      'user_id': userId,
      'username': username,
      'comment': comment,
      'is_liked': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Toggle like on a comment
  Future<void> toggleLike(int commentId) async {
    final db = await DBHelper.getDatabase();
    final comment = await db.query(
      db_table,
      where: 'id = ?',
      whereArgs: [commentId],
    );
    
    if (comment.isNotEmpty) {
      final currentLike = comment.first['is_liked'] as int;
      await db.update(
        db_table,
        {'is_liked': currentLike == 1 ? 0 : 1},
        where: 'id = ?',
        whereArgs: [commentId],
      );
    }
  }

  // Delete a comment
  Future<void> deleteComment(int commentId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      db_table,
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }
}
