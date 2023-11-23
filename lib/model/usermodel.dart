import 'package:hive_flutter/adapters.dart';
part 'usermodel.g.dart';

@HiveType(typeId: 1)
class UserDetails {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String password;
  @HiveField(3)
  final String phonenumber;
  @HiveField(4)
  final String? profilepic;
  @HiveField(5)
  final String? subject;
  @HiveField(6)
  final String? institutionname;
  @HiveField(7)
  final String? classteacher;
  @HiveField(8)
  final List<Map<String, dynamic>>? folderName;
  UserDetails({
    this.folderName,
    this.subject,
    this.institutionname,
    this.classteacher,
    required this.name,
    required this.email,
    required this.password,
    required this.phonenumber,
    this.profilepic,
  });
}
