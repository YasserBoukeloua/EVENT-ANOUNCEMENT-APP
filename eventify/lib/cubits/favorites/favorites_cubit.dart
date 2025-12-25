import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/favorites_repository.dart';
import 'package:eventify/cubits/favorites/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesInitial());

  // Load favorites
  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());

    try {
      final favorites = await _favoritesRepository.getFavorites();
      emit(FavoritesLoaded(favorites)); // Directly pass TopPicks list
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  // Add to favorites
  Future<void> addFavorite(int eventId) async {
    try {
      final success = await _favoritesRepository.addFavorite(eventId);
      if (success) {
        await loadFavorites(); // Reload list
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  // Remove from favorites
  Future<void> removeFavorite(int eventId) async {
    try {
      final success = await _favoritesRepository.removeFavorite(eventId);
      if (success) {
        await loadFavorites(); // Reload list
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int eventId) async {
    try {
      await _favoritesRepository.toggleFavorite(eventId);
      await loadFavorites(); // Reload list
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  // Check if event is favorite
  Future<bool> isFavorite(int eventId) async {
    return await _favoritesRepository.isFavorite(eventId);
  }

  // Get favorite count
  Future<int> getFavoriteCount() async {
    return await _favoritesRepository.getFavoriteCount();
  }
}