// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceModelSubWiseAdapter
    extends TypeAdapter<AttendanceModelSubWise> {
  @override
  final int typeId = 1;

  @override
  AttendanceModelSubWise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceModelSubWise(
      subjectName: fields[5] as String?,
      subjectCode: fields[0] as String?,
      overallPresent: fields[1] as int?,
      overallAbsent: fields[2] as int?,
      overallClasses: fields[3] as int?,
      overallPercentage: fields[4] as double?,
      details: (fields[6] as List?)
          ?.map((dynamic e) => (e as Map).cast<DateTime, String>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceModelSubWise obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.subjectCode)
      ..writeByte(1)
      ..write(obj.overallPresent)
      ..writeByte(2)
      ..write(obj.overallAbsent)
      ..writeByte(3)
      ..write(obj.overallClasses)
      ..writeByte(4)
      ..write(obj.overallPercentage)
      ..writeByte(5)
      ..write(obj.subjectName)
      ..writeByte(6)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceModelSubWiseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
