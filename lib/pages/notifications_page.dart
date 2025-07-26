import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Welcome!'),
          subtitle: Text('Your adventure begins now!'),
        ),
        ListTile(
          leading: Icon(Icons.campaign),
          title: Text('New Location Unlocked!'),
          subtitle: Text('Head to the River Dock.'),
        ),
        // Later you can load these from Firestore or local state
      ],
    );
  }
}
