import 'package:eventify/components/top_picks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:eventify/data/databases/db_repost.dart';
import 'package:eventify/data/databases/dbhelper.dart';
import 'repost_repo_abstract.dart';

class RepostRepository extends RepostRepositoryBase {
  final _dbReposts = DBRepostsTable();

  // Convert database record to TopPicks
  TopPicks _convertToTopPicks(Map<String, dynamic> record) {
    return TopPicks(
      record['id'],
      record['event_date'] != null
          ? DateTime.parse(record['event_date'])
          : null,
      record['event_title'] ?? 'Event',
      record['event_photo_path'] ?? '',
      record['event_location'] ?? '',
      record['event_publisher'] ?? 'User',
      record['event_is_free'] == 1,
      record['event_category'] ?? 'Repost',
      description: record['event_description'],
    );
  }

  @override
  Future<List<TopPicks>> getReposts(int userId) async {
    try {
      final results = await _dbReposts.getRepostsByUser(userId);
      return results.map((record) => _convertToTopPicks(record)).toList();
    } catch (e) {
      print('Get reposts error: $e');
      return [];
    }
  }

  @override
  Future<List<TopPicks>> getAllReposts() async {
    try {
      final results = await _dbReposts.getAllReposts();
      return results.map((record) => _convertToTopPicks(record)).toList();
    } catch (e) {
      print('Get all reposts error: $e');
      return [];
    }
  }

  @override
  Future<bool> addRepost(int userId, int eventId, {String? caption}) async {
    try {
      // Check if already reposted
      final hasReposted = await _dbReposts.hasReposted(userId, eventId);
      if (hasReposted) {
        return false;
      }

      // Save repost with user ID
      return await _dbReposts.insertRecord({
        'event_id': eventId,
        'user_id': userId, // This is the current logged-in user ID
        'caption': caption,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Add repost error: $e');
      return false;
    }
  }

  @override
  Future<bool> removeRepost(int userId, int eventId) async {
    try {
      return await _dbReposts.removeRepost(userId, eventId);
    } catch (e) {
      print('Remove repost error: $e');
      return false;
    }
  }

  @override
  Future<bool> hasReposted(int userId, int eventId) async {
    try {
      return await _dbReposts.hasReposted(userId, eventId);
    } catch (e) {
      print('Check repost error: $e');
      return false;
    }
  }
}
