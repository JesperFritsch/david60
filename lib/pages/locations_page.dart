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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: const Text('Återställ äventyret'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              String confirmText = '';
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Bekräfta återställning'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Skriv "reset" för att bekräfta återställningen av äventyret.',
                        ),
                        TextField(
                          onChanged: (value) => confirmText = value,
                          decoration: const InputDecoration(
                            labelText: 'Bekräfta',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Avbryt'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (confirmText.trim().toLowerCase() == 'reset') {
                            Navigator.pop(context, true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Återställ'),
                      ),
                    ],
                  );
                },
              );
              if (confirmed == true) {
                controller.resetAdventure();
              }
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: unlockedNodes.length,
            itemBuilder: (context, index) {
              final node = unlockedNodes[index];

              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(node.location.name),
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
          ),
        ),
      ],
    );
  }
}
