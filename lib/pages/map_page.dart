import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import '../your_vm_path_here.dart'; // Adjust import

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final vm = context.watch<LocationsViewModel>();

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(59.3293, 18.0686),
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        // MarkerLayer(
        //   markers: vm.locations.asMap().entries.map((entry) {
        //     final index = entry.key;
        //     final loc = entry.value;
        //     final unlocked = index <= vm.unlockedIndex;
        //     return Marker(
        //       point: LatLng(loc.lat, loc.lng),
        //       width: 40,
        //       height: 40,
        //       builder: (ctx) => Icon(
        //         Icons.location_pin,
        //         color: unlocked ? Colors.green : Colors.red,
        //         size: 36,
        //       ),
        //     );
        //   }).toList(),
        // ),
      ],
    );
  }
}
