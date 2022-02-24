// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list_flutter/network/outgoing/purchase/new_pur_item_dto.dart';

part 'pur_item_dto.g.dart';

@JsonSerializable(
    checked: false,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: false,
    includeIfNull: true)
class PurItemDto extends NewPurItemDto {
  int id;
  // DateTime date_created;
  // DateTime date_updated;

  int bought;
  double? bought_qnty;
  double? bought_price;
  double? bought_weight;

  PurItemDto({
    required name,
    qnty,
    comment,
    pgroup_id,
    pgroup_name,
    product_id,
    product_name,
    punit_id,
    punit_name,
    punit_brief,
    punit_fpoint,
    required this.id,
    // required this.date_created,
    // required this.date_updated,
    required this.bought,
    this.bought_qnty,
    this.bought_price,
    this.bought_weight,
  }) : super(
          name: name,
          qnty: qnty,
          comment: comment,
          pgroup_id: pgroup_id,
          pgroup_name: pgroup_name,
          product_id: product_id,
          product_name: product_name,
          punit_id: punit_id,
          punit_name: punit_name,
          punit_brief: punit_brief,
          punit_fpoint: punit_fpoint,
        );

  String get bought_qnty_string {
    if (bought_qnty != null) {
      return (punit_fpoint ?? false)
          ? bought_qnty!.toInt().toString()
          : bought_qnty!.toStringAsPrecision(2);
    } else {
      return '';
    }
  }

  set bought_qnty_string(String newValue) {
    final newDouble = double.tryParse(newValue);
    if (newDouble != null && bought_qnty != newDouble) {
      bought_qnty = newDouble;
    }
  }

  factory PurItemDto.fromJson(Map<String, dynamic> json) {
    // return _$PurItemDtoFromJson(NewPurItemDto.fromJson(json).toJson());
    try {
      //   final qntyJson = json['qnty'];
      //   if (qntyJson != null) {
      //     // otherwise "double? can not be filled from int" in runtime
      //     try {
      //       // copypaste from _$NewPurItemDtoFromJson
      //       double? qnty = (qntyJson as num?)?.toDouble();
      //       // conversion generated for base class NewPurItemDto should be exactly same in subclass PurItemDto
      //       json['qnty'] = qnty;
      //     } catch (e) {
      //       rethrow;
      //     }
      //   }

      // checkedConvert(json, 'qnty', (v) => (v as num?)?.toDouble());

      final base = NewPurItemDto.fromJson(json);
      final baseJson = base.toJson();
      baseJson.forEach((key, value) {
        json.update(key, (_) => value, ifAbsent: () => value);
      });
      return _$PurItemDtoFromJson(json);
    } on CheckedFromJsonException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
  Map<String, dynamic> toJson() => _$PurItemDtoToJson(this);
}