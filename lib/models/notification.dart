import 'package:hive/hive.dart';

part 'notification.g.dart';

@HiveType(typeId: 10)
class AppNotification {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String type; // e.g. 'Notis', 'Utmaning', etc.

  @HiveField(4)
  final bool read;

  AppNotification({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.type,
    this.read = false,
  });

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    text: text,
    timestamp: timestamp,
    type: type,
    read: read ?? this.read,
  );
}
