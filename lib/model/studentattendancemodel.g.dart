// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studentattendancemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllStudentAttendanceModelAdapter
    extends TypeAdapter<AllStudentAttendanceModel> {
  @override
  final int typeId = 4;

  @override
  AllStudentAttendanceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllStudentAttendanceModel(
      classname: fields[0] as String,
      date: fields[1] as DateTime?,
      allstudentlist: (fields[2] as List).cast<StudentAttendenceModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, AllStudentAttendanceModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.classname)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.allstudentlist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllStudentAttendanceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
