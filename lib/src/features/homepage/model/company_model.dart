import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel {
  int? companyId;
  String? name;
  double? latitude;
  double? longtitude;

  CompanyModel({this.companyId, this.name, this.latitude, this.longtitude});

  CompanyModel fromJson(Map<String, dynamic> json) {
    return _$CompanyModelFromJson(json);
  }

  @override
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return _$CompanyModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CompanyModelToJson(this);
  }
}
