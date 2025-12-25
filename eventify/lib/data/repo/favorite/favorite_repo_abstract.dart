import 'package:eventify/components/top_picks.dart';
import 'favorite_repository.dart';

abstract class FavoriteRepositoryBase {
  Future<List<TopPicks>> getFavorites(int userId);
  Future<bool> addFavorite(int userId, int eventId);
  Future<bool> removeFavorite(int userId, int eventId);
  Future<bool> isFavorite(int userId, int eventId);

  static FavoriteRepositoryBase? _instance;

  static FavoriteRepositoryBase getInstance() {
    _instance ??= FavoriteRepository();
    return _instance!;
  }
}
