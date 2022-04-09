// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasePurchaseDto _$BasePurchaseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BasePurchaseDto',
      json,
      ($checkedConvert) {
        final val = BasePurchaseDto(
          name: $checkedConvert('name', (v) => v as String),
          room: $checkedConvert('room', (v) => v as int),
          message: $checkedConvert('message', (v) => v as int),
          show_pgroup: $checkedConvert('show_pgroup', (v) => v as bool),
          show_serno: $checkedConvert('show_serno', (v) => v as bool),
          show_qnty: $checkedConvert('show_qnty', (v) => v as bool),
          show_price: $checkedConvert('show_price', (v) => v as bool),
          show_weight: $checkedConvert('show_weight', (v) => v as bool),
          show_state_unknown:
              $checkedConvert('show_state_unknown', (v) => v as bool),
          show_state_stop: $checkedConvert('show_state_stop', (v) => v as bool),
          show_state_halfdone:
              $checkedConvert('show_state_halfdone', (v) => v as bool),
          show_state_question:
              $checkedConvert('show_state_question', (v) => v as bool),
          persons_can_edit: $checkedConvert('persons_can_edit',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          persons_can_fill: $checkedConvert('persons_can_fill',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$BasePurchaseDtoToJson(BasePurchaseDto instance) =>
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
      'show_state_halfdone': instance.show_state_halfdone,
      'show_state_question': instance.show_state_question,
      'persons_can_edit': instance.persons_can_edit,
      'persons_can_fill': instance.persons_can_fill,
    };
