import 'package:hive/hive.dart';
part 'text_item_model.g.dart';
@HiveType(typeId: 3)
class TextItem extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String text;
  TextItem({this.id, required this.text});
}
