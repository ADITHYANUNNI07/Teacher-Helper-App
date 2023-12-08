// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoritesmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesModelAdapter extends TypeAdapter<FavoritesModel> {
  @override
  final int typeId = 10;

  @override
  FavoritesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritesModel(
      email: fields[1] as String,
      path: fields[0] as String,
      pdfname: fields[3] as String?,
      type: fields[2] as String,
      foldername: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoritesModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.pdfname)
      ..writeByte(4)
      ..write(obj.foldername);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
