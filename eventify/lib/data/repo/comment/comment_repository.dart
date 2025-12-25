import 'package:eventify/data/databases/db_comments.dart';

abstract class CommentRepositoryBase {
  static CommentRepositoryBase? _instance;

  static CommentRepositoryBase getInstance() {
    _instance ??= CommentRepository();
    return _instance!;
  }

  Future<List<Map<String, dynamic>>> getCommentsByEventId(int eventId);
  Future<int> addComment({
    required int eventId,
    required int userId,
    required String username,
    required String comment,
  });
  Future<void> toggleLike(int commentId);
  Future<void> deleteComment(int commentId);
}

class CommentRepository extends CommentRepositoryBase {
  final _dbComments = DBCommentsTable();

  @override
  Future<List<Map<String, dynamic>>> getCommentsByEventId(int eventId) async {
    try {
      return await _dbComments.getCommentsByEventId(eventId);
    } catch (e) {
      print('Get comments error: $e');
      return [];
    }
  }

  @override
  Future<int> addComment({
    required int eventId,
    required int userId,
    required String username,
    required String comment,
  }) async {
    try {
      return await _dbComments.addComment(
        eventId: eventId,
        userId: userId,
        username: username,
        comment: comment,
      );
    } catch (e) {
      print('Add comment error: $e');
      return -1;
    }
  }

  @override
  Future<void> toggleLike(int commentId) async {
    try {
      await _dbComments.toggleLike(commentId);
    } catch (e) {
      print('Toggle like error: $e');
    }
  }

  @override
  Future<void> deleteComment(int commentId) async {
    try {
      await _dbComments.deleteComment(commentId);
    } catch (e) {
      print('Delete comment error: $e');
    }
  }
}
