// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list_flutter/network/incoming/purchase_dto.dart';
import 'pur_item_filled_dto.dart';

part 'purchase_filled_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class PurchaseFilledDto {
  int id;
  int room;
  int message;

  bool purchased;
  double? price_total;
  double? weight_total;

  List<PurItemFilledDto> purItemsFilled;

  PurchaseFilledDto({
    required this.id,
    required this.room,
    required this.message,
    required this.purchased,
    this.price_total,
    this.weight_total,
    required this.purItemsFilled,
  });

  static fromPurchaseDto(PurchaseDto purchase) {
    return PurchaseFilledDto(
      id: purchase.id,
      room: purchase.room,
      message: purchase.message,
      purchased: purchase.purchased,
      price_total: purchase.price_total,
      weight_total: purchase.weight_total,
      purItemsFilled:
          purchase.purItems.map(PurItemFilledDto.fromPurItem).toList(),
    );
  }

  factory PurchaseFilledDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFilledDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseFilledDtoToJson(this);
}
