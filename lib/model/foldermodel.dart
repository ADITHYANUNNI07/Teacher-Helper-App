import 'package:hive_flutter/adapters.dart';
part 'foldermodel.g.dart';

@HiveType(typeId: 8)
class FolderModel {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String folderName;
  @HiveField(2)
  List<SubFolderModel> folderModel;
  @HiveField(3)
  DateTime createtime;
  @HiveField(4)
  DateTime updatetime;
  FolderModel(
      {required this.email,
      required this.folderName,
      required this.folderModel,
      required this.createtime,
      required this.updatetime});
}

@HiveType(typeId: 9)
class SubFolderModel {
  @HiveField(0)
  String path;
  @HiveField(1)
  String name;
  @HiveField(2)
  String pdfname;

  SubFolderModel({
    required this.path,
    required this.name,
    required this.pdfname,
  });
}
