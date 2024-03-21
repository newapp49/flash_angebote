import 'package:hive/hive.dart';

part 'image_item.model.g.dart';

@HiveType(typeId: 4)
class ImageItem extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String text;
  @HiveField(2)
  int adet;
  @HiveField(3)
  String bottomText;
  @HiveField(4)
  String imageUrl;
  ImageItem({this.id, required this.text, required this.adet, required this.bottomText, required this.imageUrl});
}
