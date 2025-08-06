import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/adventure_controller.dart';
import 'dart:async';

class MapViewModel extends ChangeNotifier {
  LatLng? _currentPosition;
  LatLng? _lastMapCenter;
  LatLng? _centerOnLocation;
  bool _hasInitialized = false;
  StreamSubscription<Position>? _positionStream;
  final AdventureController adventureController;

  MapViewModel({required this.adventureController});

  Future<void> initializePosition() async {
    if (_hasInitialized) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;
    final position = await Geolocator.getCurrentPosition();
    // final position = LatLng(57.689942, 11.990628);
    _currentPosition = LatLng(position.latitude, position.longitude);
    _lastMapCenter ??= _currentPosition;
    _hasInitialized = true;
    notifyListeners();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((position) {
      _currentPosition = LatLng(position.latitude, position.longitude);
      adventureController.completeProximityNodes(_currentPosition!);
      adventureController.startProximityNodes(_currentPosition!);
      notifyListeners();
    });
  }

  void centerMapOnUser(Function(LatLng) onCenter) {
    if (_currentPosition != null) {
      onCenter(_currentPosition!);
    }
  }

  void updateMapCenter(LatLng center) {
    _lastMapCenter = center;
  }

  LatLng? get currentPosition => _currentPosition;
  LatLng? get lastMapCenter => _lastMapCenter;
  LatLng? get centerOnLocation => _centerOnLocation;
  bool get hasInitialized => _hasInitialized;

  void setCenterOnLocation(LatLng? location) {
    _centerOnLocation = location;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
