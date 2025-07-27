import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_viewmodel.dart'; // Adjust if needed

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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();
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
                // Add any other markers like custom dragons here
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
