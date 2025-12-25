import 'package:equatable/equatable.dart';
import 'package:eventify/models/user_model.dart';

class ProfileState extends Equatable {
  final User? user;
  final Map<String, int> userStats;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.userStats = const {},
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    Map<String, int>? userStats,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      userStats: userStats ?? this.userStats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [user, userStats, isLoading, error];
}
