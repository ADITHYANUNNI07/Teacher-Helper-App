import 'package:hive_flutter/adapters.dart';
part 'classmodel.g.dart';

@HiveType(typeId: 2)
class ClassModel {
  @HiveField(0)
  final String classname;
  @HiveField(1)
  final String department;
  @HiveField(2)
  final String collegename;
  @HiveField(3)
  final String image;
  @HiveField(4)
  final String email;
  ClassModel({
    required this.classname,
    required this.department,
    required this.collegename,
    required this.image,
    required this.email,
  });
}
