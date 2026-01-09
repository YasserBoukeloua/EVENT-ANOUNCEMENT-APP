import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/data/repo/notification/notification_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _repository = NotificationRepository();

  NotificationsCubit() : super(NotificationsInitial());

  Future<void> loadNotifications(int userId) async {
    try {
      emit(NotificationsLoading());
      final notifications = await _repository.getNotificationsForUser(userId);
      final unreadCount = await _repository.getUnreadCount(userId);
      
      print('DEBUG: [NOTIF] Loaded ${notifications.length} notifications for user $userId');
      
      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAsRead(int notificationId, int userId) async {
    try {
      await _repository.markAsRead(notificationId);
      print('DEBUG: [NOTIF] Marked $notificationId as read');
      // Reload to update state
      loadNotifications(userId);
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAllAsRead(int userId) async {
    try {
      await _repository.markAllAsRead(userId);
      print('DEBUG: [NOTIF] Marked all as read for user $userId');
      loadNotifications(userId);
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> deleteNotification(int notificationId, int userId) async {
    try {
      await _repository.deleteNotification(notificationId);
      print('DEBUG: [NOTIF] Deleted notification $notificationId');
      loadNotifications(userId);
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
  
  void clearNotifications() {
    emit(NotificationsInitial());
  }
}
