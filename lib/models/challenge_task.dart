import 'package:hive/hive.dart';

part 'challenge_task.g.dart';

@HiveType(typeId: 11)
class ChallengeTask {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final int? timeoutSeconds;
  @HiveField(4)
  final bool unlocked;
  @HiveField(5)
  final bool completed;
  @HiveField(6)
  final DateTime? startedAt;

  ChallengeTask({
    required this.id,
    required this.title,
    required this.description,
    this.timeoutSeconds,
    this.unlocked = false,
    this.completed = false,
    this.startedAt,
  });

  ChallengeTask copyWith({
    bool? unlocked,
    bool? completed,
    DateTime? startedAt,
  }) {
    return ChallengeTask(
      id: id,
      title: title,
      description: description,
      timeoutSeconds: timeoutSeconds,
      unlocked: unlocked ?? this.unlocked,
      completed: completed ?? this.completed,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}
