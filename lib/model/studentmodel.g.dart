// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studentmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentModelAdapter extends TypeAdapter<StudentModel> {
  @override
  final int typeId = 3;

  @override
  StudentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentModel(
      studentname: fields[1] as String,
      email: fields[2] as String,
      parentphone: fields[3] as String,
      phoneno: fields[4] as String,
      address: fields[5] as String,
      addmissionno: fields[6] as int,
      classname: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.classname)
      ..writeByte(1)
      ..write(obj.studentname)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.parentphone)
      ..writeByte(4)
      ..write(obj.phoneno)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.addmissionno);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
