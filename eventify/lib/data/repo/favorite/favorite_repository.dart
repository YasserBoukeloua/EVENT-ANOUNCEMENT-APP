import 'package:eventify/components/top_picks.dart';
import 'package:eventify/services/api_service.dart';
import 'favorite_repo_abstract.dart';

class FavoriteRepository extends FavoriteRepositoryBase {
  final _apiService = ApiService();

  // Convert API record to TopPicks model
  TopPicks _convertToTopPicks(Map<String, dynamic> favorite) {
    final event = favorite['event'];
    if (event == null) {
      return TopPicks(
        favorite['id'],
        null,
        'Unknown Event',
        null,
        '',
        'Unknown',
        true,
        'General',
      );
    }

    // Get photo URL from event
    String? photoPath;
    if (event['photos'] != null && (event['photos'] as List).isNotEmpty) {
      String? imageUrl = event['photos'][0]['image'];
      if (imageUrl != null && imageUrl.startsWith('http://')) {
        imageUrl = imageUrl.replaceFirst('http://', 'https://');
      }
      photoPath = imageUrl;
    }

    return TopPicks(
      event['id'],
      event['date'] != null ? DateTime.parse(event['date']) : null,
      event['title'],
      photoPath,
      event['location'],
      event['creator']?['username'] ?? 'Unknown',
      true,
      'General',
      description: event['description'],
      registrationLink: event['registration_link'],
    );
  }

  @override
  Future<List<TopPicks>> getFavorites(int userId) async {
    try {
      final favorites = await _apiService.getFavoritesByUser(userId);
      return favorites
          .map((f) => _convertToTopPicks(f as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Get favorites error: $e');
      return [];
    }
  }

  @override
  Future<bool> addFavorite(int userId, int eventId) async {
    try {
      await _apiService.createFavorite(userId, eventId);
      return true;
    } catch (e) {
      print('Add favorite error: $e');
      return false;
    }
  }

  @override
  Future<bool> removeFavorite(int userId, int eventId) async {
    try {
      return await _apiService.removeFavorite(userId, eventId);
    } catch (e) {
      print('Remove favorite error: $e');
      return false;
    }
  }

  @override
  Future<bool> isFavorite(int userId, int eventId) async {
    try {
      return await _apiService.hasFavorited(userId, eventId);
    } catch (e) {
      print('Check favorite error: $e');
      return false;
    }
  }
}
