import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_viewmodel.dart'; // Adjust if needed
import '../controllers/adventure_controller.dart';
import '../models/adventure.dart'; // Adjust if needed

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapViewModel>().initializePosition();
    });
  }

  void _onMarkerTapped(BuildContext context, AdventureNode node) {
    final userPosition = context.read<MapViewModel>().currentPosition;
    final controller = context.read<AdventureController>();
    if (userPosition == null) return;

    final proxResult = controller.checkProximityToNode(node.id, userPosition);
    final isCloseEnough = proxResult.isCloseEnough;
    final meters = proxResult.distanceMeters;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        if (!isCloseEnough) {
          // User is not close enough to the location
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(node.location.name),
                const SizedBox(height: 8),
                Text(
                  'Du är ${meters.toStringAsFixed(1)} meter bort. Kom närmare!',
                ),
              ],
            ),
          );
        } else if (!node.started) {
          // At location, not started yet: show start button
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(node.location.name)),
              ElevatedButton(
                onPressed: () {
                  controller.startNode(node.id);
                  Navigator.pop(context);
                },
                child: const Text('Starta platsen'),
              ),
            ],
          );
        } else if (!node.completed) {
          // At location, started, show task progress and complete button if all tasks are done
          final completedCount = node.tasks.where((t) => t.completed).length;
          final totalCount = node.tasks.length;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(node.location.name)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Utmaningar: $completedCount / $totalCount'),
              ),
              if (controller.canCompleteNode(node.id))
                ElevatedButton(
                  onPressed: () {
                    controller.completeNode(node.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Slutför platsen'),
                ),
            ],
          );
        } else {
          // Already completed
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(node.location.name),
                const Text('Du har redan slutfört detta äventyr!'),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = context.read<MapViewModel>();
    if (viewModel.centerOnLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapController.move(viewModel.centerOnLocation!, 16); // desired zoom
        viewModel.setCenterOnLocation(null); // Clear after centering
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();
    final adventureController = context.watch<AdventureController>();
    final center = viewModel.lastMapCenter ?? const LatLng(57.70887, 11.97456);

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 14,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                viewModel.updateMapCenter(position.center);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                if (viewModel.currentPosition != null)
                  Marker(
                    point: viewModel.currentPosition!,
                    width: 40,
                    height: 40,
                    rotate: false,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),
                ...adventureController.visibleNodes.map(
                  (node) => Marker(
                    point: node.location.toLatLng(),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _onMarkerTapped(context, node),
                      child: Icon(
                        Icons.location_pin,
                        color:
                            node.completed
                                ? Colors.green
                                : (node.unlocked ? Colors.red : Colors.grey),
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              viewModel.centerMapOnUser((position) {
                mapController.move(position, mapController.camera.zoom);
                mapController.rotate(0);
              });
            },
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
