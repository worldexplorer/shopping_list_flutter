// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditPurchaseDto _$EditPurchaseDtoFromJson(Map<String, dynamic> json) =>
    EditPurchaseDto(
      id: json['id'] as int,
      name: json['name'],
      room: json['room'],
      message: json['message'],
      show_pgroup: json['show_pgroup'],
      show_serno: json['show_serno'],
      show_qnty: json['show_qnty'],
      show_price: json['show_price'],
      show_weight: json['show_weight'],
      show_state_unknown: json['show_state_unknown'],
      show_state_stop: json['show_state_stop'],
      persons_can_edit: json['persons_can_edit'],
      persons_can_fill: json['persons_can_fill'],
      purItems: (json['purItems'] as List<dynamic>)
          .map((e) => PurItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EditPurchaseDtoToJson(EditPurchaseDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'room': instance.room,
      'message': instance.message,
      'show_pgroup': instance.show_pgroup,
      'show_serno': instance.show_serno,
      'show_qnty': instance.show_qnty,
      'show_price': instance.show_price,
      'show_weight': instance.show_weight,
      'show_state_unknown': instance.show_state_unknown,
      'show_state_stop': instance.show_state_stop,
      'persons_can_edit': instance.persons_can_edit,
      'persons_can_fill': instance.persons_can_fill,
      'id': instance.id,
      'purItems': instance.purItems.map((e) => e.toJson()).toList(),
    };
