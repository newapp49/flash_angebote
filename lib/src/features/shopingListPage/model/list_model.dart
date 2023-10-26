
class ListModel {
  String name;
  Result result = Result(list: []);
  ListModel({required this.name,required this.result});
}

class Result {
  List<dynamic> list;
  Result({required this.list});
}
