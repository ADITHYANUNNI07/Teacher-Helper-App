import 'package:hive_flutter/adapters.dart';
part 'studentmodel.g.dart';

@HiveType(typeId: 3)
class StudentModel {
  @HiveField(0)
  final String classname;
  @HiveField(1)
  final String studentname;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String parentphone;
  @HiveField(4)
  final String phoneno;
  @HiveField(5)
  final String address;
  @HiveField(6)
  final int addmissionno;

  StudentModel({
    required this.studentname,
    required this.email,
    required this.parentphone,
    required this.phoneno,
    required this.address,
    required this.addmissionno,
    required this.classname,
  });
}
