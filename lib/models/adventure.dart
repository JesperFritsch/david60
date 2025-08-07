import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import 'challenge_task.dart';

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

  @HiveField(3)
  final String? markerIconAsset;

  @HiveField(4)
  final List<String> nextIds;

  @HiveField(5)
  final bool unlocked;

  @HiveField(6)
  final bool completed;

  @HiveField(7)
  final bool started;

  @HiveField(8)
  final List<ChallengeTask> tasks;

  AdventureNode({
    required this.id,
    required this.location,
    this.markerIconAsset,
    this.nextIds = const [],
    this.started = false,
    this.unlocked = false,
    this.completed = false,
    this.tasks = const [],
  });

  AdventureNode copyWith({
    bool? unlocked,
    bool? completed,
    bool? started,
    List<ChallengeTask>? tasks,
  }) {
    return AdventureNode(
      id: id,
      location: location,
      markerIconAsset: markerIconAsset,
      nextIds: nextIds,
      unlocked: unlocked ?? this.unlocked,
      started: started ?? this.started,
      completed: completed ?? this.completed,
      tasks: tasks ?? this.tasks,
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

  void reset() {
    final nodeKeys = nodes.keys.toList();
    final resetNodes = {
      for (int i = 0; i < nodeKeys.length; i++)
        nodeKeys[i]: nodes[nodeKeys[i]]!.copyWith(
          unlocked: i == 0, // only first node unlocked
          completed: false,
          started: false,
          tasks:
              nodes[nodeKeys[i]]!.tasks
                  .map(
                    (task) => task.copyWith(
                      completed: false,
                      unlocked: false,
                      startedAt: null,
                      completedAt: null,
                    ),
                  )
                  .toList(),
        ),
    };
    nodes
      ..clear()
      ..addAll(resetNodes);
  }
}
