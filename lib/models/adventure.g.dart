// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 0;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      name: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdventureNodeAdapter extends TypeAdapter<AdventureNode> {
  @override
  final int typeId = 1;

  @override
  AdventureNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdventureNode(
      id: fields[0] as String,
      location: fields[1] as Location,
      markerIconAsset: fields[3] as String?,
      nextIds: (fields[4] as List).cast<String>(),
      started: fields[7] as bool,
      unlocked: fields[5] as bool,
      completed: fields[6] as bool,
      tasks: (fields[8] as List).cast<ChallengeTask>(),
    );
  }

  @override
  void write(BinaryWriter writer, AdventureNode obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.markerIconAsset)
      ..writeByte(4)
      ..write(obj.nextIds)
      ..writeByte(5)
      ..write(obj.unlocked)
      ..writeByte(6)
      ..write(obj.completed)
      ..writeByte(7)
      ..write(obj.started)
      ..writeByte(8)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdventureNodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdventureAdapter extends TypeAdapter<Adventure> {
  @override
  final int typeId = 2;

  @override
  Adventure read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Adventure(
      id: fields[0] as String,
      title: fields[1] as String,
      nodes: (fields[2] as Map).cast<String, AdventureNode>(),
    );
  }

  @override
  void write(BinaryWriter writer, Adventure obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.nodes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdventureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
