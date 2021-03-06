// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

import '../../incoming/purchase/purchase_dto.dart';
import 'base_purchase_dto.dart';
import 'new_pur_item_dto.dart';

part 'new_purchase_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class NewPurchaseDto extends BasePurchaseDto {
  int? replyto_id;
  int? copiedfrom_id;

  List<NewPurItemDto> newPurItems;

  NewPurchaseDto({
    required name,
    required room,
    required message,
    required show_pgroup,
    required show_serno,
    required show_qnty,
    required show_price,
    required show_weight,
    required show_state_unknown,
    required show_state_stop,
    required show_state_halfdone,
    required show_state_question,
    required this.replyto_id,
    required this.copiedfrom_id,
    required persons_can_edit,
    required persons_can_fill,
    required this.newPurItems,
  }) : super(
          name: name,
          room: room,
          message: message,
          show_pgroup: show_pgroup,
          show_serno: show_serno,
          show_qnty: show_qnty,
          show_price: show_price,
          show_weight: show_weight,
          show_state_unknown: show_state_unknown,
          show_state_stop: show_state_stop,
          show_state_halfdone: show_state_halfdone,
          show_state_question: show_state_question,
          persons_can_edit: persons_can_edit,
          persons_can_fill: persons_can_fill,
        );

  factory NewPurchaseDto.fromPurchaseDto(PurchaseDto purchase) {
    return NewPurchaseDto(
      name: purchase.name,
      room: purchase.room,
      message: purchase.message,
      show_pgroup: purchase.show_pgroup,
      show_serno: purchase.show_serno,
      show_qnty: purchase.show_qnty,
      show_price: purchase.show_price,
      show_weight: purchase.show_weight,
      show_state_unknown: purchase.show_state_unknown,
      show_state_stop: purchase.show_state_stop,
      show_state_halfdone: purchase.show_state_halfdone,
      show_state_question: purchase.show_state_question,
      replyto_id: purchase.replyto_id,
      copiedfrom_id: purchase.copiedfrom_id,
      persons_can_edit: purchase.persons_can_edit,
      persons_can_fill: purchase.persons_can_fill,
      newPurItems: purchase.purItems.map(NewPurItemDto.fromPurItem).toList(),
    );
  }

  factory NewPurchaseDto.fromJson(Map<String, dynamic> json) =>
      _$NewPurchaseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NewPurchaseDtoToJson(this);
}
