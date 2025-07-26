import 'package:flutter/material.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Old Oak Tree'),
          subtitle: Text('Find the carved initials.'),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('River Dock'),
          subtitle: Text('Look under the bench.'),
        ),
        // Add more locations dynamically later
      ],
    );
  }
}
