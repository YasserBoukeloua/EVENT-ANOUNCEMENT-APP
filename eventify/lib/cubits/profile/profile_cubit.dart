import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/profile_repository.dart';
import 'package:eventify/repositories/auth_repository.dart';
import 'package:eventify/cubits/profile/profile_state.dart';
import 'package:eventify/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  ProfileCubit(this._profileRepository, this._authRepository)
      : super(const ProfileState());

  // Set user from authentication
  void setUser(User user) {
    emit(state.copyWith(user: user));
  }

  // Load user profile and stats
  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await _profileRepository.getProfile();
      final stats = await _profileRepository.getUserStats();

      emit(state.copyWith(
        user: user,
        userStats: stats,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Update username
  Future<void> updateUsername(String username) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final updatedUser = await _profileRepository.updateUsername(username);
      emit(state.copyWith(
        user: updatedUser,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Update email
  Future<void> updateEmail(String email) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final updatedUser = await _profileRepository.updateEmail(email);
      emit(state.copyWith(
        user: updatedUser,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Update profile picture
  Future<void> updateProfilePicture(String path) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final updatedUser = await _profileRepository.updateProfilePicture(path);
      emit(state.copyWith(
        user: updatedUser,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _profileRepository.clearUser();
      emit(const ProfileState());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
