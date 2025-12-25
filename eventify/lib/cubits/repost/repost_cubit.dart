import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/reposts_repository.dart';
import 'package:eventify/cubits/repost/repost_state.dart';

class RepostCubit extends Cubit<RepostState> {
  final RepostsRepository _repostRepository;

  RepostCubit(this._repostRepository) : super(const RepostInitial());

  // Load reposts for current user
  Future<void> loadReposts() async {
    emit(const RepostLoading());

    try {
      final reposts = await _repostRepository.getReposts();
      emit(RepostLoaded(reposts));
    } catch (e) {
      emit(RepostError(e.toString()));
    }
  }

  // Load all reposts (feed)
  Future<void> loadAllReposts() async {
    emit(const RepostLoading());

    try {
      final reposts = await _repostRepository.getAllReposts();
      emit(RepostLoaded(reposts));
    } catch (e) {
      emit(RepostError(e.toString()));
    }
  }

  // Add repost
  Future<void> addRepost(int eventId, {String? caption}) async {
    try {
      final success = await _repostRepository.addRepost(eventId, caption: caption);
      if (success) {
        await loadReposts(); // Reload list
      }
    } catch (e) {
      emit(RepostError(e.toString()));
    }
  }

  // Remove repost
  Future<void> removeRepost(int eventId) async {
    try {
      final success = await _repostRepository.removeRepost(eventId);
      if (success) {
        await loadReposts(); // Reload list
      }
    } catch (e) {
      emit(RepostError(e.toString()));
    }
  }

  // Toggle repost
  Future<void> toggleRepost(int eventId, {String? caption}) async {
    try {
      await _repostRepository.toggleRepost(eventId, caption: caption);
      await loadReposts(); // Reload list
    } catch (e) {
      emit(RepostError(e.toString()));
    }
  }

  // Check if event is reposted
  Future<bool> isReposted(int eventId) async {
    return await _repostRepository.hasReposted(eventId);
  }
}