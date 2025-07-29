import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'dart:js_util' as js_util;
import '../models/notification.dart';
import '../repositories/interface/notification_interface.dart';

class NotificationController extends ChangeNotifier {
  final INotificationRepository _repository;

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  NotificationController({required INotificationRepository repository})
    : _repository = repository {
    _loadNotifications();
  }

  Future<void> _showLocalNotification(String title, String body) async {
    // Use browser Notification API directly for web
    if (js.context.hasProperty('Notification')) {
      var permission = web.Notification.permission;
      if (permission != 'granted') {
        final jsPerm = web.Notification.requestPermission();
        permission = await js_util.promiseToFuture<String>(jsPerm);
      }
      if (permission == 'granted') {
        web.Notification(title, web.NotificationOptions(body: body));
      }
    }
  }

  Future<void> _loadNotifications() async {
    _notifications = await _repository.getNotifications();
    notifyListeners();
  }

  Future<void> addNotification({
    required String text,
    String type = 'Notis',
  }) async {
    final id = '${DateTime.now().millisecondsSinceEpoch}_${text.hashCode}';
    final now = DateTime.now();
    final notification = AppNotification(
      id: id,
      text: text,
      timestamp: now,
      type: type,
    );
    await _showLocalNotification(type, text);
    await _repository.addNotification(notification);
    _notifications = await _repository.getNotifications();
    notifyListeners();
  }

  Future<void> removeNotification(String id) async {
    await _repository.removeNotification(id);
    _notifications = await _repository.getNotifications();
    notifyListeners();
  }
}
