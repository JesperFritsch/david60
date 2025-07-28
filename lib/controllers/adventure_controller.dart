import 'package:flutter/foundation.dart';
import '../models/adventure.dart';
import '../repositories/interface/adventure_interface.dart';
import '../data/default_adventure.dart';
import 'package:latlong2/latlong.dart';

const proximityThreshold = 20; // meters

class ProximityResult {
  final bool isCloseEnough;
  final double distanceMeters;

  ProximityResult(this.isCloseEnough, this.distanceMeters);
}

class AdventureController extends ChangeNotifier {
  final IAdventureRepository repository;
  Adventure? _adventure;

  AdventureController({required this.repository});

  Adventure? get adventure => _adventure;
  bool get isLoaded => _adventure != null;

  Future<void> loadAdventure(String id) async {
    _adventure = await repository.loadAdventure(id);

    if (_adventure == null) {
      // If no adventure exists yet, preload the default
      _adventure = createDefaultAdventure();
      await repository.saveAdventure(_adventure!);
    }

    notifyListeners();
  }

  Future<void> saveAdventure() async {
    if (_adventure != null) {
      await repository.saveAdventure(_adventure!);
    }
  }

  List<AdventureNode> get visibleNodes =>
      _adventure?.nodes.values.where((n) => n.unlocked).toList() ?? [];

  AdventureNode? getNode(String id) => _adventure?.nodes[id];

  void completeNode(String nodeId) {
    if (_adventure == null) return;
    final node = _adventure!.nodes[nodeId];
    if (node == null || node.completed) return;

    // Mark this node completed
    _adventure!.nodes[nodeId] = node.copyWith(completed: true);

    // Unlock next nodes
    for (final nextId in node.nextIds) {
      final next = _adventure!.nodes[nextId];
      if (next != null && !next.unlocked) {
        _adventure!.nodes[nextId] = next.copyWith(unlocked: true);
      }
    }

    notifyListeners();
    saveAdventure();
  }

  ProximityResult checkProximityToNode(String nodeId, LatLng userPosition) {
    final node = _adventure?.nodes[nodeId];
    if (node == null) return ProximityResult(false, double.infinity);

    final nodePosition = LatLng(
      node.location.latitude,
      node.location.longitude,
    );
    final distanceMeters = Distance().as(
      LengthUnit.Meter,
      userPosition,
      nodePosition,
    );

    final isCloseEnough = distanceMeters <= proximityThreshold;
    return ProximityResult(isCloseEnough, distanceMeters);
  }

  void resetAdventure() {
    // Optional: Reset all nodes to initial state
    if (_adventure == null) return;
    final resetNodes = {
      for (final entry in _adventure!.nodes.entries)
        entry.key: entry.value.copyWith(unlocked: false, completed: false),
    };
    _adventure = Adventure(
      id: _adventure!.id,
      title: _adventure!.title,
      nodes: resetNodes,
    );
    notifyListeners();
    saveAdventure();
  }
}
