// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 0;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      studentImage: fields[0] as Uint8List?,
      studentID: fields[1] as String?,
      studentName: fields[2] as String?,
      studentDOB: fields[3] as DateTime?,
      studentGender: fields[4] as String?,
      studentCategory: fields[5] as String?,
      studentAdmission: fields[6] as String?,
      studentBranchName: fields[7] as String?,
      studentDegree: fields[8] as String?,
      studentFullPart: fields[9] as String?,
      studentSpecialization: fields[10] as String?,
      studentSection: fields[11] as String?,
      studentCurrentSemester: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.studentImage)
      ..writeByte(1)
      ..write(obj.studentID)
      ..writeByte(2)
      ..write(obj.studentName)
      ..writeByte(3)
      ..write(obj.studentDOB)
      ..writeByte(4)
      ..write(obj.studentGender)
      ..writeByte(5)
      ..write(obj.studentCategory)
      ..writeByte(6)
      ..write(obj.studentAdmission)
      ..writeByte(7)
      ..write(obj.studentBranchName)
      ..writeByte(8)
      ..write(obj.studentDegree)
      ..writeByte(9)
      ..write(obj.studentFullPart)
      ..writeByte(10)
      ..write(obj.studentSpecialization)
      ..writeByte(11)
      ..write(obj.studentSection)
      ..writeByte(12)
      ..write(obj.studentCurrentSemester);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
