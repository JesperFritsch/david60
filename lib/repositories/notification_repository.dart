import 'package:hive/hive.dart';
import '../repositories/interface/notification_interface.dart';
import '../models/notification.dart';

class NotificationRepository implements INotificationRepository {
  static const String boxName = 'notifications';

  Future<Box<AppNotification>> _openBox() async {
    return await Hive.openBox<AppNotification>(boxName);
  }

  @override
  Future<void> addNotification(AppNotification notification) async {
    final box = await _openBox();
    await box.put(notification.id, notification);
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    final box = await _openBox();
    final notification = box.get(id);
    if (notification != null) {
      await box.put(id, notification.copyWith(read: true));
    }
  }

  @override
  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }

  @override
  Future<void> removeNotification(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
