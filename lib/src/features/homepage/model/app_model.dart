import 'package:wingo/src/features/homepage/model/company_model.dart';
import 'package:wingo/src/features/homepage/model/flyer_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_model.g.dart';

@JsonSerializable()
class ApplicationModel {
  List<CompanyModel?>? company;
  List<FlyerModel?>? flyers;

  ApplicationModel({this.company, this.flyers});

  ApplicationModel fromJson(Map<String, dynamic> json) {
    return _$ApplicationModelFromJson(json);
  }

  @override
  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return _$ApplicationModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ApplicationModelToJson(this);
  }
}
