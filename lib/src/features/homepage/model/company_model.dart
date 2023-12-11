import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel {
  int? companyId;
  String? companyLogo;
  String? companyName;
  double? latitude;
  double? longtitude;
  bool? isFavourite;

  CompanyModel(
      {this.companyId,
      this.companyName,
      this.latitude,
      this.longtitude,
      this.companyLogo});

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
