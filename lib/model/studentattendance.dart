import 'package:hive_flutter/adapters.dart';
part 'studentattendance.g.dart';

@HiveType(typeId: 5)
class StudentAttendenceModel {
  @HiveField(0)
  final String studentname;
  @HiveField(1)
  final int admissionNo;
  @HiveField(2)
  bool ispresent;
  @HiveField(3)
  DateTime date;
  StudentAttendenceModel({
    required this.admissionNo,
    required this.studentname,
    this.ispresent = false,
    required this.date,
  });
}
