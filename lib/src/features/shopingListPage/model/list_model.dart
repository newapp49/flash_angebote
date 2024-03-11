import 'package:hive/hive.dart';
part 'list_model.g.dart';
@HiveType(typeId: 2)
class ListModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<dynamic> result = [];

  ListModel({required this.name, required this.result});
}

