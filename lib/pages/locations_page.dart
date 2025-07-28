import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/adventure_controller.dart';
import '../viewmodels/map_viewmodel.dart';
import '../main.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AdventureController>();
    final unlockedNodes = controller.visibleNodes;

    if (!controller.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (unlockedNodes.isEmpty) {
      return const Center(child: Text('Inga platser är upplåsta än.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: unlockedNodes.length,
      itemBuilder: (context, index) {
        final node = unlockedNodes[index];

        return ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(node.location.name),
          subtitle: Text(node.completed ? node.quest ?? '' : ''),
          trailing:
              node.completed
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.lock_open, color: Colors.grey),
          onTap: () {
            context.read<MapViewModel>().setCenterOnLocation(
              node.location.toLatLng(),
            );
            MainNavigation.setTab(context, 0); // Switch to map tab
          },
        );
      },
    );
  }
}
