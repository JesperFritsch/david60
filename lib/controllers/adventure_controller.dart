import 'package:flutter/foundation.dart';
import '../models/adventure.dart';
import '../repositories/interface/adventure_interface.dart';
import '../data/default_adventure.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/notification_controller.dart';
import 'dart:async';
import '../models/challenge_task.dart';

const proximityThreshold = 20; // meters

class ProximityResult {
  final bool isCloseEnough;
  final double distanceMeters;

  ProximityResult(this.isCloseEnough, this.distanceMeters);
}

class AdventureController extends ChangeNotifier {
  final IAdventureRepository repository;
  final NotificationController notificationController;
  Adventure? _adventure;

  AdventureController({
    required this.repository,
    required this.notificationController,
  });

  Adventure? get adventure => _adventure;
  bool get isLoaded => _adventure != null;

  final Map<String, int> _taskCountdowns = {};
  final Map<String, Timer> _timers = {};

  Map<String, int> get taskCountdowns => _taskCountdowns;

  void startTaskCountdown(String nodeId, String taskId) {
    if (_adventure == null) return;
    final node = _adventure!.nodes[nodeId];
    if (node == null) return;
    ChallengeTask? task;
    try {
      task = node.tasks.firstWhere((t) => t.id == taskId);
    } catch (_) {
      return;
    }
    final key = '$nodeId|$taskId';
    // If a countdown is already running for this task, do not replace it
    if (_timers.containsKey(key)) return;

    // If startedAt is not set, persist it now
    if (task.startedAt == null) {
      final updatedTasks = [
        for (final t in node.tasks)
          t.id == taskId ? t.copyWith(startedAt: DateTime.now()) : t,
      ];
      _adventure!.nodes[nodeId] = node.copyWith(tasks: updatedTasks);
      saveAdventure();
      // Update local reference for countdown
      task = updatedTasks.firstWhere((t) => t.id == taskId);
    }

    final int totalSeconds = task.timeoutSeconds ?? 0;
    final DateTime start = task.startedAt!;
    final int elapsed = DateTime.now().difference(start).inSeconds;
    final int remaining = (totalSeconds - elapsed).clamp(0, totalSeconds);
    _taskCountdowns[key] = remaining;
    if (remaining > 0) {
      _timers[key] = Timer.periodic(const Duration(seconds: 1), (timer) {
        final int newRemaining = (_taskCountdowns[key] ?? 1) - 1;
        _taskCountdowns[key] = newRemaining;
        notifyListeners();
        if (newRemaining <= 0) {
          timer.cancel();
        }
      });
    }
  }

  void stopTaskCountdown(String nodeId, String taskId) {
    final key = '$nodeId|$taskId';
    if (_timers.containsKey(key)) {
      _timers[key]!.cancel();
      _timers.remove(key);
      _taskCountdowns.remove(key);
      notifyListeners();
    }
  }

  void stopAllCountdowns() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _taskCountdowns.clear();
  }

  void initializeCountdowns() {
    stopAllCountdowns();
    if (_adventure == null) return;
    for (final node in _adventure!.nodes.values) {
      for (final task in node.tasks) {
        if (task.unlocked && task.startedAt != null && !task.completed) {
          startTaskCountdown(node.id, task.id);
        }
      }
    }
  }

  Future<void> loadAdventure(String id) async {
    _adventure = await repository.loadAdventure(id);

    if (_adventure == null) {
      // If no adventure exists yet, preload the default
      _adventure = createDefaultAdventure();
      await repository.saveAdventure(_adventure!);
    }
    initializeCountdowns();
    notifyListeners();
  }

  void dispose() {
    stopAllCountdowns();
    super.dispose();
  }

  Future<void> saveAdventure() async {
    if (_adventure != null) {
      await repository.saveAdventure(_adventure!);
    }
  }

  List<AdventureNode> get visibleNodes =>
      _adventure?.nodes.values.where((n) => n.unlocked).toList() ?? [];

  AdventureNode? getNode(String id) => _adventure?.nodes[id];

  void startNode(String nodeId) {
    if (_adventure == null) return;
    final node = _adventure!.nodes[nodeId];
    if (node == null || node.completed) return;
    // Unlock all tasks for this node
    final updatedTasks = [
      for (final task in node.tasks)
        task.unlocked ? task : task.copyWith(unlocked: true),
    ];
    // Send notifications for newly unlocked tasks
    notificationController.addNotification(
      text: 'Nya uppgifter tillgängliga i ${node.location.name}',
      type: 'Info',
    );
    _adventure!.nodes[nodeId] = node.copyWith(
      tasks: updatedTasks,
      started: true,
    );
    notifyListeners();
    saveAdventure();
  }

  void startTask(String nodeId, String taskId) {
    if (_adventure == null) return;
    final node = _adventure!.nodes[nodeId];
    if (node == null) return;
    final task = node.tasks.firstWhere((t) => t.id == taskId);
    if (task.unlocked && task.startedAt == null) {
      final updatedTasks = [
        for (final t in node.tasks)
          t.id == taskId ? t.copyWith(startedAt: DateTime.now()) : t,
      ];
      _adventure!.nodes[nodeId] = node.copyWith(tasks: updatedTasks);
      startTaskCountdown(nodeId, taskId);
      saveAdventure();
    }
    notifyListeners();
  }

  void completeTask(String nodeId, String taskId) {
    if (_adventure == null) return;
    final node = _adventure!.nodes[nodeId];
    if (node == null) return;
    final now = DateTime.now();
    final updatedTasks = [
      for (final task in node.tasks)
        task.id == taskId
            ? task.copyWith(completed: true, completedAt: now)
            : task,
    ];
    _adventure!.nodes[nodeId] = node.copyWith(tasks: updatedTasks);
    // Stop countdown for this task
    stopTaskCountdown(nodeId, taskId);
    notifyListeners();
    saveAdventure();
  }

  bool canCompleteNode(String nodeId) {
    final node = _adventure?.nodes[nodeId];
    if (node == null) return false;
    return node.tasks.isEmpty || node.tasks.every((t) => t.completed);
  }

  void completeNode(String nodeId) {
    if (_adventure == null) return;
    final node = _adventure!.nodes[nodeId];
    if (node == null || node.completed) return;
    // Only allow completion if all tasks are completed
    if (!canCompleteNode(nodeId)) return;
    // Mark this node completed
    _adventure!.nodes[nodeId] = node.copyWith(completed: true);
    // Unlock next nodes
    int nrUnlocked = 0;
    for (final nextId in node.nextIds) {
      final next = _adventure!.nodes[nextId];
      if (next != null && !next.unlocked) {
        nrUnlocked++;
        _adventure!.nodes[nextId] = next.copyWith(unlocked: true);
      }
    }
    if (nrUnlocked > 0) {
      notificationController.addNotification(
        text:
            'Du har låst upp $nrUnlocked ${nrUnlocked == 1 ? 'nytt' : 'nya'} steg i äventyret!',
        type: 'Info',
      );
    } else {
      notificationController.addNotification(
        text: 'Grattis farsan nu har du klarat alla steg i detta äventyr!',
        type: 'Success',
      );
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

    // final isCloseEnough = distanceMeters <= proximityThreshold;
    final isCloseEnough = true;
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

  // Utility methods for ChallengeTask status
  bool isTaskTimed(ChallengeTask task) => task.timeoutSeconds != null;
  bool isTaskCompleted(ChallengeTask task) => task.completed;
  bool hasTaskQuestion(ChallengeTask task) =>
      task.question != null &&
      task.correctAnswers != null &&
      task.correctAnswers!.isNotEmpty;
  bool isTaskCompletedWithinTime(ChallengeTask task) {
    if (!isTaskTimed(task) ||
        task.completedAt == null ||
        task.startedAt == null ||
        task.timeoutSeconds == null)
      return false;
    return task.completedAt!.difference(task.startedAt!).inSeconds <=
        task.timeoutSeconds!;
  }

  bool isTaskCompletedAfterTimeout(ChallengeTask task) {
    if (!isTaskTimed(task) ||
        task.completedAt == null ||
        task.startedAt == null ||
        task.timeoutSeconds == null)
      return false;
    return task.completedAt!.difference(task.startedAt!).inSeconds >
        task.timeoutSeconds!;
  }

  // function to complete all nodes that can complete in the proximity of the user
  void completeProximityNodes(LatLng userPosition) {
    if (_adventure == null) return;
    for (final node in _adventure!.nodes.values) {
      if (node.unlocked && !node.completed) {
        final proximityResult = checkProximityToNode(node.id, userPosition);
        if (proximityResult.isCloseEnough && canCompleteNode(node.id)) {
          completeNode(node.id);
        }
      }
    }
  }

  void startProximityNodes(LatLng userPosition) {
    if (_adventure == null) return;
    for (final node in _adventure!.nodes.values) {
      if (node.unlocked && !node.started && !node.completed) {
        final proximityResult = checkProximityToNode(node.id, userPosition);
        if (proximityResult.isCloseEnough) {
          startNode(node.id);
        }
      }
    }
  }
}
