// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeTaskAdapter extends TypeAdapter<ChallengeTask> {
  @override
  final int typeId = 11;

  @override
  ChallengeTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChallengeTask(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      timeoutSeconds: fields[3] as int?,
      unlocked: fields[4] as bool,
      completed: fields[5] as bool,
      startedAt: fields[6] as DateTime?,
      question: fields[7] as String?,
      correctAnswers: (fields[8] as List?)?.cast<String>(),
      completedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeTask obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.timeoutSeconds)
      ..writeByte(4)
      ..write(obj.unlocked)
      ..writeByte(5)
      ..write(obj.completed)
      ..writeByte(6)
      ..write(obj.startedAt)
      ..writeByte(7)
      ..write(obj.question)
      ..writeByte(8)
      ..write(obj.correctAnswers)
      ..writeByte(9)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
