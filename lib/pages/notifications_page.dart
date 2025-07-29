import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = context.watch<NotificationController>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children:
          notificationController.notifications.map((notification) {
            return ListTile(
              title: Text(notification.type),
              subtitle: Text(notification.text),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  notificationController.removeNotification(notification.id);
                },
              ),
              onTap: () {
                // Handle notification tap if needed
              },
            );
          }).toList(),
    );
  }
}
