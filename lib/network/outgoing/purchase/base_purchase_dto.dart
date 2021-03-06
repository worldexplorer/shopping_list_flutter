// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'base_purchase_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: false,
    includeIfNull: true)
// base for NewPurchaseDto , EditPurchaseDto; FillPurchaseDto is out of inheritance
class BasePurchaseDto {
  String name;

  int room;
  int message;

  bool show_pgroup;
  bool show_serno;
  bool show_qnty;
  bool show_price;
  bool show_weight;
  bool show_state_unknown;
  bool show_state_stop;
  bool show_state_halfdone;
  bool show_state_question;

  List<int> persons_can_edit;
  List<int> persons_can_fill;

  BasePurchaseDto({
    required this.name,
    required this.room,
    required this.message,
    required this.show_pgroup,
    required this.show_serno,
    required this.show_qnty,
    required this.show_price,
    required this.show_weight,
    required this.show_state_unknown,
    required this.show_state_stop,
    required this.show_state_halfdone,
    required this.show_state_question,
    required this.persons_can_edit,
    required this.persons_can_fill,
  });

  factory BasePurchaseDto.fromJson(Map<String, dynamic> json) =>
      _$BasePurchaseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BasePurchaseDtoToJson(this);
}
