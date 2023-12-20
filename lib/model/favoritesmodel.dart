import 'package:hive_flutter/adapters.dart';
part 'favoritesmodel.g.dart';

@HiveType(typeId: 10)
class FavoritesModel {
  @HiveField(0)
  String path;
  @HiveField(1)
  String email;
  @HiveField(2)
  String type;
  @HiveField(3)
  String pdfname;
  @HiveField(4)
  String foldername;
  FavoritesModel(
      {required this.email,
      required this.path,
      required this.pdfname,
      required this.type,
      required this.foldername});
}
