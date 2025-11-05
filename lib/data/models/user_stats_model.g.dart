// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatsModelAdapter extends TypeAdapter<UserStatsModel> {
  @override
  final int typeId = 1;

  @override
  UserStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatsModel(
      totalSessions: fields[0] as int,
      totalMinutes: fields[1] as int,
      weeklyStreak: fields[2] as int,
      mindfulDays: fields[3] as int,
      lastSessionDate: fields[4] as DateTime?,
      sessionHistory: (fields[5] as List?)?.cast<SessionHistoryEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStatsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalSessions)
      ..writeByte(1)
      ..write(obj.totalMinutes)
      ..writeByte(2)
      ..write(obj.weeklyStreak)
      ..writeByte(3)
      ..write(obj.mindfulDays)
      ..writeByte(4)
      ..write(obj.lastSessionDate)
      ..writeByte(5)
      ..write(obj.sessionHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionHistoryEntryAdapter extends TypeAdapter<SessionHistoryEntry> {
  @override
  final int typeId = 2;

  @override
  SessionHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionHistoryEntry(
      date: fields[0] as DateTime,
      durationMinutes: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SessionHistoryEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.durationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
