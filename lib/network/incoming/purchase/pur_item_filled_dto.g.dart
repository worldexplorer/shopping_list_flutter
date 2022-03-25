// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pur_item_filled_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurItemFilledDto _$PurItemFilledDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PurItemFilledDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'id',
            'name',
            'room',
            'message',
            'purchase',
            'bought',
            'bought_qnty',
            'bought_price',
            'bought_weight',
            'comment',
            'person_bought',
            'person_bought_ident'
          ],
        );
        final val = PurItemFilledDto(
          id: $checkedConvert('id', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          room: $checkedConvert('room', (v) => v as int),
          message: $checkedConvert('message', (v) => v as int),
          purchase: $checkedConvert('purchase', (v) => v as int),
          bought: $checkedConvert('bought', (v) => v as int),
          bought_qnty:
              $checkedConvert('bought_qnty', (v) => (v as num?)?.toDouble()),
          bought_price:
              $checkedConvert('bought_price', (v) => (v as num?)?.toDouble()),
          bought_weight:
              $checkedConvert('bought_weight', (v) => (v as num?)?.toDouble()),
          comment: $checkedConvert('comment', (v) => v as String?),
          person_bought: $checkedConvert('person_bought', (v) => v as int),
          person_bought_ident:
              $checkedConvert('person_bought_ident', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$PurItemFilledDtoToJson(PurItemFilledDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'room': instance.room,
      'message': instance.message,
      'purchase': instance.purchase,
      'bought': instance.bought,
      'bought_qnty': instance.bought_qnty,
      'bought_price': instance.bought_price,
      'bought_weight': instance.bought_weight,
      'comment': instance.comment,
      'person_bought': instance.person_bought,
      'person_bought_ident': instance.person_bought_ident,
    };
