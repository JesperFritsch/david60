import '../../models/notification.dart';

abstract class INotificationRepository {
  Future<void> addNotification(AppNotification notification);
  Future<List<AppNotification>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> clearAll();
  Future<void> removeNotification(String id);
}
