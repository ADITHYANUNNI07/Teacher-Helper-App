import 'package:eduvista/model/studentattendance.dart';
import 'package:hive_flutter/adapters.dart';
part 'studentattendancemodel.g.dart';

@HiveType(typeId: 4)
class AllStudentAttendanceModel {
  @HiveField(0)
  final String classname;
  @HiveField(1)
  final DateTime? date;
  @HiveField(2)
  final List<StudentAttendenceModel> allstudentlist;
  AllStudentAttendanceModel(
      {required this.classname,
      required this.date,
      required this.allstudentlist});
}
