import 'package:eventify/components/top_picks.dart';
import 'package:eventify/data/repo/favorite/favorite_repository.dart';
import 'package:eventify/services/session_service.dart';

class FavoritesRepository {
  final FavoriteRepository _favoriteRepository;
  FavoritesRepository(this._favoriteRepository);

  // Get favorites for current user
  Future<List<TopPicks>> getFavorites() async {
    final userId = await SessionService.getUserId();
    if (userId == null) return [];
    return _favoriteRepository.getFavorites(userId);
  }

  // Add favorite for current user
  Future<bool> addFavorite(int eventId) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return false;
    return _favoriteRepository.addFavorite(userId, eventId);
  }

  // Remove favorite for current user
  Future<bool> removeFavorite(int eventId) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return false;
    return _favoriteRepository.removeFavorite(userId, eventId);
  }

  // Toggle favorite for current user
  Future<void> toggleFavorite(int eventId) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return;

    final isFav = await _favoriteRepository.isFavorite(userId, eventId);
    if (isFav) {
      await _favoriteRepository.removeFavorite(userId, eventId);
    } else {
      await _favoriteRepository.addFavorite(userId, eventId);
    }
  }

  // Check if event is favorite for current user
  Future<bool> isFavorite(int eventId) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return false;
    return _favoriteRepository.isFavorite(userId, eventId);
  }

  // Get favorite count for current user
  Future<int> getFavoriteCount() async {
    final userId = await SessionService.getUserId();
    if (userId == null) return 0;

    final favorites = await getFavorites();
    return favorites.length;
  }
}
