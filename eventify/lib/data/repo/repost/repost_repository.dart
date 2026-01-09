import 'package:eventify/components/top_picks.dart';
import 'package:eventify/services/api_service.dart';
import 'repost_repo_abstract.dart';

class RepostRepository extends RepostRepositoryBase {
  final _apiService = ApiService();

  // Convert API record to TopPicks
  TopPicks _convertToTopPicks(Map<String, dynamic> record) {
    final event = record['event'];
    if (event == null) {
      return TopPicks(
        record['id'],
        null,
        'Event',
        null,
        '',
        record['user']?['username'] ?? 'User',
        true,
        'Repost',
      );
    }

    // Get first photo if available - construct full URL
    String? photoPath;
    if (event['photos'] != null && (event['photos'] as List).isNotEmpty) {
      final imagePath = event['photos'][0]['image'];
      if (imagePath != null && imagePath.toString().isNotEmpty) {
        if (imagePath.toString().startsWith('http')) {
          photoPath = imagePath.toString();
          // Convert http to https for secure connection
          if (photoPath.startsWith('http://')) {
            photoPath = photoPath.replaceFirst('http://', 'https://');
          }
        } else {
          photoPath = '${ApiService.baseUrl}$imagePath';
        }
      }
    }

    return TopPicks(
      event['id'],
      event['date'] != null ? DateTime.parse(event['date']) : null,
      event['title'] ?? 'Event',
      photoPath,
      event['location'] ?? '',
      record['user']?['username'] ?? event['creator']?['username'] ?? 'User',
      true,
      'Repost',
      description: event['description'],
      registrationLink: event['registration_link'],
    );
  }

  @override
  Future<List<TopPicks>> getReposts(int userId) async {
    try {
      final results = await _apiService.getRepostsByUser(userId);
      return results
          .map((record) => _convertToTopPicks(record as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Get reposts error: $e');
      return [];
    }
  }

  @override
  Future<List<TopPicks>> getAllReposts() async {
    try {
      final results = await _apiService.getReposts();
      return results
          .map((record) => _convertToTopPicks(record as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Get all reposts error: $e');
      return [];
    }
  }

  @override
  Future<bool> addRepost(int userId, int eventId, {String? caption}) async {
    try {
      // Check if already reposted
      final alreadyReposted = await _apiService.hasReposted(userId, eventId);
      if (alreadyReposted) {
        return false;
      }

      await _apiService.createRepost(userId, eventId, caption: caption);
      return true;
    } catch (e) {
      print('Add repost error: $e');
      return false;
    }
  }

  @override
  Future<bool> removeRepost(int userId, int eventId) async {
    try {
      return await _apiService.removeRepost(userId, eventId);
    } catch (e) {
      print('Remove repost error: $e');
      return false;
    }
  }

  @override
  Future<bool> hasReposted(int userId, int eventId) async {
    try {
      return await _apiService.hasReposted(userId, eventId);
    } catch (e) {
      print('Check repost error: $e');
      return false;
    }
  }
}
