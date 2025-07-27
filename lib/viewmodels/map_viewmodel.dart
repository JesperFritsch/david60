import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapViewModel extends ChangeNotifier {
  LatLng? _currentPosition;
  LatLng? _lastMapCenter;
  bool _hasInitialized = false;
  StreamSubscription<Position>? _positionStream;

  Future<void> initializePosition() async {
    if (_hasInitialized) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;
    final position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _lastMapCenter ??= _currentPosition;
    _hasInitialized = true;
    notifyListeners();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((position) {
      _currentPosition = LatLng(position.latitude, position.longitude);
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
  bool get hasInitialized => _hasInitialized;

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
