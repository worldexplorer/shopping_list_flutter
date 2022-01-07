// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_filled_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseFilledDto _$PurchaseFilledDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PurchaseFilledDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'id',
            'room',
            'message',
            'purchased',
            'price_total',
            'weight_total',
            'purItemsFilled'
          ],
        );
        final val = PurchaseFilledDto(
          id: $checkedConvert('id', (v) => v as int),
          room: $checkedConvert('room', (v) => v as int),
          message: $checkedConvert('message', (v) => v as int),
          purchased: $checkedConvert('purchased', (v) => v as bool),
          price_total:
              $checkedConvert('price_total', (v) => (v as num?)?.toDouble()),
          weight_total:
              $checkedConvert('weight_total', (v) => (v as num?)?.toDouble()),
          purItemsFilled: $checkedConvert(
              'purItemsFilled',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      PurItemFilledDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$PurchaseFilledDtoToJson(PurchaseFilledDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room': instance.room,
      'message': instance.message,
      'purchased': instance.purchased,
      'price_total': instance.price_total,
      'weight_total': instance.weight_total,
      'purItemsFilled': instance.purItemsFilled.map((e) => e.toJson()).toList(),
    };
