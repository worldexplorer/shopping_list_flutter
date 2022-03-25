// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_fill_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseFillDto _$PurchaseFillDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PurchaseFillDto',
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
        final val = PurchaseFillDto(
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
                  .map(
                      (e) => PurItemFillDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$PurchaseFillDtoToJson(PurchaseFillDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room': instance.room,
      'message': instance.message,
      'purchased': instance.purchased,
      'price_total': instance.price_total,
      'weight_total': instance.weight_total,
      'purItemsFilled': instance.purItemsFilled.map((e) => e.toJson()).toList(),
    };
