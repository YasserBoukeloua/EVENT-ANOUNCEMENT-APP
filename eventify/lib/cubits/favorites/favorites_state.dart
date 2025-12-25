import 'package:equatable/equatable.dart';
import 'package:eventify/components/top_picks.dart'; // Import TopPicks

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<TopPicks> favorites; // Changed to TopPicks

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String error;

  const FavoritesError(this.error);

  @override
  List<Object?> get props => [error];
}