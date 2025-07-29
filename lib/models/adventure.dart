import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

part 'adventure.g.dart';

@HiveType(typeId: 0)
class Location {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  LatLng toLatLng() => LatLng(latitude, longitude);
}

@HiveType(typeId: 1)
class AdventureNode {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Location location;

  @HiveField(2)
  final String? quest;

  @HiveField(3)
  final String? markerIconAsset;

  @HiveField(4)
  final List<String> nextIds;

  @HiveField(5)
  final bool unlocked;

  @HiveField(6)
  final bool completed;

  @HiveField(7)
  final String? completionPrompt;

  @HiveField(8)
  final String? notificationText;

  @HiveField(9)
  final int? notificationDelaySeconds;

  AdventureNode({
    required this.id,
    required this.location,
    this.quest,
    this.markerIconAsset,
    this.nextIds = const [],
    this.unlocked = false,
    this.completed = false,
    this.completionPrompt,
    this.notificationText,
    this.notificationDelaySeconds,
  });

  AdventureNode copyWith({
    bool? unlocked,
    bool? completed,
    String? completionPrompt,
    String? notificationText,
    int? notificationDelaySeconds,
  }) {
    return AdventureNode(
      id: id,
      location: location,
      quest: quest,
      markerIconAsset: markerIconAsset,
      nextIds: nextIds,
      unlocked: unlocked ?? this.unlocked,
      completed: completed ?? this.completed,
      completionPrompt: completionPrompt ?? this.completionPrompt,
      notificationText: notificationText ?? this.notificationText,
      notificationDelaySeconds:
          notificationDelaySeconds ?? this.notificationDelaySeconds,
    );
  }
}

@HiveType(typeId: 2)
class Adventure {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final Map<String, AdventureNode> nodes;

  Adventure({required this.id, required this.title, required this.nodes});

  AdventureNode? get currentStep => nodes.values.firstWhere(
    (n) => n.unlocked && !n.completed,
    orElse: () => nodes.values.first,
  );

  AdventureNode? get nextLocked => nodes.values.firstWhere(
    (n) => !n.unlocked,
    orElse: () => nodes.values.last,
  );

  bool get isCompleted => nodes.values.every((n) => n.completed);
}
