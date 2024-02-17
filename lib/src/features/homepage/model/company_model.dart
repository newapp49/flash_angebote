import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel {
  String? uid;
  String? companyLogo;
  String? companyName;
  double? latitude;
  double? longtitude;
  bool? isFavourite;

  CompanyModel(
      {this.uid,
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
