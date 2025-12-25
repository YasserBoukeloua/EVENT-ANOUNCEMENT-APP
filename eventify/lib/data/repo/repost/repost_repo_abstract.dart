import 'package:eventify/components/top_picks.dart';
import 'package:eventify/data/repo/repost/repost_repository.dart';

abstract class RepostRepositoryBase {
  Future<List<TopPicks>> getReposts(int userId);
  Future<List<TopPicks>> getAllReposts();
  Future<bool> addRepost(int userId, int eventId, {String? caption});
  Future<bool> removeRepost(int userId, int eventId);
  Future<bool> hasReposted(int userId, int eventId);

  static RepostRepositoryBase? _instance;

  static RepostRepositoryBase getInstance() {
    _instance ??= RepostRepository();
    return _instance!;
  }
}