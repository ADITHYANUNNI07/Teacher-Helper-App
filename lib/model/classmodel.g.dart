// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassModelAdapter extends TypeAdapter<ClassModel> {
  @override
  final int typeId = 2;

  @override
  ClassModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassModel(
      classname: fields[0] as String,
      department: fields[1] as String,
      collegename: fields[2] as String,
      image: fields[3] as String,
      email: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClassModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.classname)
      ..writeByte(1)
      ..write(obj.department)
      ..writeByte(2)
      ..write(obj.collegename)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
