import 'package:hive_flutter/adapters.dart';
part 'questionsmodel.g.dart';

@HiveType(typeId: 6)
class Questionsmodel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final DateTime examdate;
  @HiveField(2)
  final DateTime examtime;
  @HiveField(3)
  final List<String> questionslist;
  @HiveField(4)
  final String email;
  Questionsmodel({
    required this.title,
    required this.examdate,
    required this.examtime,
    required this.questionslist,
    required this.email,
  });
}
