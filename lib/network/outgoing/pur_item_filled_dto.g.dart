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
            'bought',
            'bought_qnty',
            'bought_price',
            'bought_weight',
            'comment'
          ],
        );
        final val = PurItemFilledDto(
          id: $checkedConvert('id', (v) => v as int),
          bought: $checkedConvert('bought', (v) => v as bool?),
          bought_qnty:
              $checkedConvert('bought_qnty', (v) => (v as num?)?.toDouble()),
          bought_price:
              $checkedConvert('bought_price', (v) => (v as num?)?.toDouble()),
          bought_weight:
              $checkedConvert('bought_weight', (v) => (v as num?)?.toDouble()),
          comment: $checkedConvert('comment', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$PurItemFilledDtoToJson(PurItemFilledDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bought': instance.bought,
      'bought_qnty': instance.bought_qnty,
      'bought_price': instance.bought_price,
      'bought_weight': instance.bought_weight,
      'comment': instance.comment,
    };
