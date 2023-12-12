// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usermodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 1;

  @override
  UserDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetails(
      folderName: (fields[8] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
      subject: fields[5] as String?,
      institutionname: fields[6] as String?,
      classteacher: fields[7] as String?,
      name: fields[0] as String,
      email: fields[1] as String,
      password: fields[2] as String,
      phonenumber: fields[3] as String,
      profilepic: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.phonenumber)
      ..writeByte(4)
      ..write(obj.profilepic)
      ..writeByte(5)
      ..write(obj.subject)
      ..writeByte(6)
      ..write(obj.institutionname)
      ..writeByte(7)
      ..write(obj.classteacher)
      ..writeByte(8)
      ..write(obj.folderName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
