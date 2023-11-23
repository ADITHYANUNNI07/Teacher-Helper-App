// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studentattendance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAttendenceModelAdapter
    extends TypeAdapter<StudentAttendenceModel> {
  @override
  final int typeId = 5;

  @override
  StudentAttendenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentAttendenceModel(
      admissionNo: fields[1] as int,
      studentname: fields[0] as String,
      ispresent: fields[2] as bool,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StudentAttendenceModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.studentname)
      ..writeByte(1)
      ..write(obj.admissionNo)
      ..writeByte(2)
      ..write(obj.ispresent)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAttendenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
