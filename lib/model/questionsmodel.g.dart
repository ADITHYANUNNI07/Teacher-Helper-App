// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionsmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionsmodelAdapter extends TypeAdapter<Questionsmodel> {
  @override
  final int typeId = 6;

  @override
  Questionsmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Questionsmodel(
      title: fields[0] as String,
      examdate: fields[1] as DateTime,
      examtime: fields[2] as DateTime,
      questionslist: (fields[3] as List).cast<String>(),
      email: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Questionsmodel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.examdate)
      ..writeByte(2)
      ..write(obj.examtime)
      ..writeByte(3)
      ..write(obj.questionslist)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionsmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
