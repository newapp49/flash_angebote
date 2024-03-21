import 'package:hive/hive.dart';
import 'package:wingo/src/features/shopingListPage/model/list_model.dart';

part 'repo.g.dart';

@HiveType(typeId: 1)
class Repo extends HiveObject {
  @HiveField(0)
  List<ListModel> list = <ListModel>[];
}
