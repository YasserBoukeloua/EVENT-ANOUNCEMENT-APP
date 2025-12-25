import 'package:eventify/components/top_picks.dart';
import 'package:eventify/data/repo/repost/repost_repository.dart' as base;
import 'package:eventify/services/session_service.dart';

class RepostsRepository {
  final base.RepostRepository _repostRepository;

  RepostsRepository(this._repostRepository);

  // Get reposts for current user
  Future<List<TopPicks>> getReposts() async {
    final userId = await SessionService.getUserId();
    if (userId == null) return [];
    return _repostRepository.getReposts(userId);
  }

  // Get all reposts (feed)
  Future<List<TopPicks>> getAllReposts() async {
    return _repostRepository.getAllReposts();
  }

  // Add repost for current user
  Future<bool> addRepost(int eventId, {String? caption}) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return false;
    return _repostRepository.addRepost(userId, eventId, caption: caption);
  }

  // Remove repost for current user
  Future<bool> removeRepost(int eventId) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return false;
    return _repostRepository.removeRepost(userId, eventId);
  }

  // Check if current user has reposted
  Future<bool> hasReposted(int eventId) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return false;
    return _repostRepository.hasReposted(userId, eventId);
  }

  // Toggle repost status
  Future<void> toggleRepost(int eventId, {String? caption}) async {
    final userId = await SessionService.getUserId();
    if (userId == null) return;

    final hasReposted = await _repostRepository.hasReposted(userId, eventId);
    if (hasReposted) {
      await _repostRepository.removeRepost(userId, eventId);
    } else {
      await _repostRepository.addRepost(userId, eventId, caption: caption);
    }
  }
}