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
          allowedKeys: const ['id', 'room', 'message', 'purItems'],
        );
        final val = PurchaseFilledDto(
          id: $checkedConvert('id', (v) => v as int),
          room: $checkedConvert('room', (v) => v as int),
          message: $checkedConvert('message', (v) => v as int),
          purItems: $checkedConvert(
              'purItems',
              (v) => (v as List<dynamic>)
                  .map((e) => PurItemDto.fromJson(e as Map<String, dynamic>))
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
      'purItems': instance.purItems.map((e) => e.toJson()).toList(),
    };
