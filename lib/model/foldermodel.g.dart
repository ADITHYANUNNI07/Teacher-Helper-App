// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foldermodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderModelAdapter extends TypeAdapter<FolderModel> {
  @override
  final int typeId = 8;

  @override
  FolderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FolderModel(
      email: fields[0] as String,
      folderName: fields[1] as String,
      folderModel: (fields[2] as List).cast<SubFolderModel>(),
      createtime: fields[3] as DateTime,
      updatetime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FolderModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.folderName)
      ..writeByte(2)
      ..write(obj.folderModel)
      ..writeByte(3)
      ..write(obj.createtime)
      ..writeByte(4)
      ..write(obj.updatetime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubFolderModelAdapter extends TypeAdapter<SubFolderModel> {
  @override
  final int typeId = 9;

  @override
  SubFolderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubFolderModel(
      path: fields[0] as String,
      name: fields[1] as String,
      pdfname: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubFolderModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pdfname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubFolderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
