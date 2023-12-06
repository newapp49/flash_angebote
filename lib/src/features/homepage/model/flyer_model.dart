import 'package:json_annotation/json_annotation.dart';

part 'flyer_model.g.dart';

@JsonSerializable()
class FlyerModel {
  int? companyId;
  int? pageCount;
  String? picture;
  String? expireDate;
  List<String?>? flyerUrls;

  FlyerModel(
      {this.companyId,
      this.pageCount,
      this.picture,
      this.expireDate,
      this.flyerUrls});

  FlyerModel fromJson(Map<String, dynamic> json) {
    return _$FlyerModelFromJson(json);
  }

  @override
  factory FlyerModel.fromJson(Map<String, dynamic> json) {
    return _$FlyerModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FlyerModelToJson(this);
  }
}
