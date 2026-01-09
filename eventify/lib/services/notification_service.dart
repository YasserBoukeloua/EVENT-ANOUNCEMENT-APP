import 'package:eventify/data/repo/notification/notification_repository.dart';
import 'package:eventify/data/databases/db_users.dart';
import 'package:eventify/data/databases/db_events.dart';
import 'package:eventify/data/databases/db_repost.dart';

class NotificationService {
  final NotificationRepository _notificationRepository = NotificationRepository();
  final DBUsersTable _dbUsers = DBUsersTable();
  final DBEventsTable _dbEvents = DBEventsTable();
  final DBRepostsTable _dbReposts = DBRepostsTable();

  // Notify all users about a new event
  Future<void> notifyNewEvent(int eventId, String eventTitle) async {
    try {
      final users = await _dbUsers.getRecords();
      for (var user in users) {
        await _notificationRepository.createNotification(
          userId: user['id'],
          type: 'new_event',
          title: 'New Event Available',
          message: 'Check out "$eventTitle"!',
          relatedId: eventId,
          relatedType: 'event',
        );
        print('DEBUG: [NOTIF] Created: new_event for user ${user['id']}');
      }
    } catch (e) {
      print('Error notifying new event: $e');
    }
  }

  // Notify event owner about a repost
  Future<void> notifyRepost(int eventId, int reposterId, String reposterName) async {
    try {
      final event = await _dbEvents.getRecordById(eventId);
      if (event != null) {
        final publisherUsername = event['publisher'];
        // Find user by username (since events table stores username)
        final users = await _dbUsers.getRecords();
        final owner = users.firstWhere(
          (u) => u['username'] == publisherUsername,
          orElse: () => {},
        );

        if (owner.isNotEmpty && owner['id'] != reposterId) {
          // Only notify if owner is admin/verified (as per requirements)
          if (owner['is_certified'] == 1) {
            await _notificationRepository.createNotification(
              userId: owner['id'],
              type: 'repost',
              title: 'New Repost',
              message: '$reposterName reposted your event "${event['title']}"',
              relatedId: eventId, // Linking to event since repost ID might not be available yet or less relevant
              relatedType: 'event',
            );
            print('DEBUG: [NOTIF] Created: repost for user ${owner['id']}');
          }
        }
      }
    } catch (e) {
      print('Error notifying repost: $e');
    }
  }

  // Notify owner about a comment (on event or repost)
  Future<void> notifyComment({
    required int entityId,
    required String entityType, // 'event' or 'repost'
    required int commenterId,
    required String commenterName,
  }) async {
    try {
      int? ownerId;
      String? title;
      bool shouldNotify = false;

      if (entityType == 'event') {
        final event = await _dbEvents.getRecordById(entityId);
        if (event != null) {
          final publisherUsername = event['publisher'];
          final users = await _dbUsers.getRecords();
          final owner = users.firstWhere(
            (u) => u['username'] == publisherUsername,
            orElse: () => {},
          );
          if (owner.isNotEmpty) {
            ownerId = owner['id'];
            title = event['title'];
            // Notify if owner is certified (admin)
            if (owner['is_certified'] == 1) {
              shouldNotify = true;
            }
          }
        }
      } else if (entityType == 'repost') {
        final repost = await _dbReposts.getRecordById(entityId);
        if (repost != null) {
          ownerId = repost['user_id'];
          // Fetch event title for context
          final event = await _dbEvents.getRecordById(repost['event_id']);
          title = event != null ? event['title'] : 'a repost';
          shouldNotify = true; // Regular users get notified for comments on their reposts
        }
      }

      if (shouldNotify && ownerId != null && ownerId != commenterId) {
        await _notificationRepository.createNotification(
          userId: ownerId,
          type: 'comment',
          title: 'New Comment',
          message: '$commenterName commented on "$title"',
          relatedId: entityId,
          relatedType: entityType,
        );
        print('DEBUG: [NOTIF] Created: comment for user $ownerId');
      }
    } catch (e) {
      print('Error notifying comment: $e');
    }
  }

  // Notify repost owner about a like
  Future<void> notifyLike(int repostId, int likerId, String likerName) async {
    try {
      final repost = await _dbReposts.getRecordById(repostId);
      if (repost != null) {
        final ownerId = repost['user_id'];
        
        if (ownerId != likerId) {
           // Fetch event title for context
          final event = await _dbEvents.getRecordById(repost['event_id']);
          final title = event != null ? event['title'] : 'your repost';

          await _notificationRepository.createNotification(
            userId: ownerId,
            type: 'like',
            title: 'New Like',
            message: '$likerName liked your repost of "$title"',
            relatedId: repostId,
            relatedType: 'repost',
          );
          print('DEBUG: [NOTIF] Created: like for user $ownerId');
        }
      }
    } catch (e) {
      print('Error notifying like: $e');
    }
  }
}
