// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'pur_item_filled_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class PurItemFilledDto {
  int id;
  // int room;
  // int message;
  // int purchase;

  bool? bought;
  double? bought_qnty;
  double? bought_price;
  double? bought_weight;
  String? comment;

  PurItemFilledDto({
    required this.id,
    // required this.room,
    // required this.message,
    // required this.purchase,
    required this.bought,
    this.bought_qnty,
    this.bought_price,
    this.bought_weight,
    this.comment,
  });

  factory PurItemFilledDto.fromJson(Map<String, dynamic> json) =>
      _$PurItemFilledDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PurItemFilledDtoToJson(this);
}
