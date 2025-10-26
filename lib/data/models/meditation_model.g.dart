// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeditationModelAdapter extends TypeAdapter<MeditationModel> {
  @override
  final int typeId = 0;

  @override
  MeditationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeditationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      instructor: fields[2] as String,
      category: fields[3] as String,
      sessionCount: fields[4] as int,
      durationMinutes: fields[5] as int,
      isLocked: fields[6] as bool,
      hasImage: fields[7] as bool,
      imageUrl: fields[8] as String?,
      gradientColors: (fields[9] as List).cast<String>(),
      type: fields[10] as String,
      minDuration: fields[11] as int?,
      maxDuration: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MeditationModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.instructor)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.sessionCount)
      ..writeByte(5)
      ..write(obj.durationMinutes)
      ..writeByte(6)
      ..write(obj.isLocked)
      ..writeByte(7)
      ..write(obj.hasImage)
      ..writeByte(8)
      ..write(obj.imageUrl)
      ..writeByte(9)
      ..write(obj.gradientColors)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.minDuration)
      ..writeByte(12)
      ..write(obj.maxDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
