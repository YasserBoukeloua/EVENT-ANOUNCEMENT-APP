import 'package:eventify/components/top_picks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:eventify/data/databases/db_favorites.dart';
import 'package:eventify/data/databases/db_events.dart';
import 'package:eventify/data/databases/dbhelper.dart';
import 'favorite_repo_abstract.dart';

class FavoriteRepository extends FavoriteRepositoryBase {
  final _dbFavorites = DBFavoritesTable();
  final _dbEvents = DBEventsTable();

  // Convert database record to TopPicks model
  TopPicks _convertToTopPicks(Map<String, dynamic> record) {
    return TopPicks(
      record['id'],
      record['date'] != null ? DateTime.parse(record['date']) : null,
      record['title'],
      record['photo_path'],
      record['location'],
      record['publisher'],
      record['is_free'] == 1,
      record['category'],
    );
  }

  @override
  Future<List<TopPicks>> getFavorites(int userId) async {
    try {
      final database = await DBHelper.getDatabase();
      
      // Join favorites with events to get event details
      final results = await database.rawQuery('''
        SELECT e.* FROM events e
        INNER JOIN favorites f ON e.id = f.event_id
        WHERE f.user_id = ?
        ORDER BY f.saved_at DESC
      ''', [userId]);

      return results.map((record) => _convertToTopPicks(record)).toList();
    } catch (e) {
      print('Get favorites error: $e');
      return [];
    }
  }

  @override
  Future<bool> addFavorite(int userId, int eventId) async {
    try {
      return await _dbFavorites.insertRecord({
        'user_id': userId,
        'event_id': eventId,
        'saved_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Add favorite error: $e');
      return false;
    }
  }

  @override
  Future<bool> removeFavorite(int userId, int eventId) async {
    try {
      final database = await DBHelper.getDatabase();
      
      await database.delete(
        'favorites',
        where: 'user_id = ? AND event_id = ?',
        whereArgs: [userId, eventId],
      );
      
      return true;
    } catch (e) {
      print('Remove favorite error: $e');
      return false;
    }
  }

  @override
  Future<bool> isFavorite(int userId, int eventId) async {
    try {
      final database = await DBHelper.getDatabase();
      
      final results = await database.query(
        'favorites',
        where: 'user_id = ? AND event_id = ?',
        whereArgs: [userId, eventId],
      );

      return results.isNotEmpty;
    } catch (e) {
      print('Check favorite error: $e');
      return false;
    }
  }
}
