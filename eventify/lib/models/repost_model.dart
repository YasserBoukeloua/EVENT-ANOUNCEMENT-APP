import 'package:eventify/models/event_model.dart';

class Repost {
  final int id;
  final int eventId;
  final int userId;
  final String? caption;
  final DateTime createdAt;

  Repost({
    required this.id,
    required this.eventId,
    required this.userId,
    this.caption,
    required this.createdAt,
  });

  // For database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'user_id': userId,
      'caption': caption,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // For displaying in UI
  Map<String, dynamic> toDisplayMap() {
    return {
      'id': id,
      'event_id': eventId,
      'user_id': userId,
      'caption': caption ?? '',
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class RepostDisplay {
  final Event event;
  final String username;
  final String? userPhoto;
  final String? caption;
  final DateTime repostDate;

  RepostDisplay({
    required this.event,
    required this.username,
    this.userPhoto,
    this.caption,
    required this.repostDate,
  });

  String get userDisplayName => username;

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(repostDate);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }
}