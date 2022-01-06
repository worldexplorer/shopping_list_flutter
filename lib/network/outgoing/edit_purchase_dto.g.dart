// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditPurchaseDto _$EditPurchaseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'EditPurchaseDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'id',
            'name',
            'room',
            'message',
            'show_pgroup',
            'show_price',
            'show_qnty',
            'show_weight',
            'persons_can_edit',
            'purItems'
          ],
        );
        final val = EditPurchaseDto(
          id: $checkedConvert('id', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          room: $checkedConvert('room', (v) => v as int),
          message: $checkedConvert('message', (v) => v as int),
          show_pgroup: $checkedConvert('show_pgroup', (v) => v as bool),
          show_price: $checkedConvert('show_price', (v) => v as bool),
          show_qnty: $checkedConvert('show_qnty', (v) => v as bool),
          show_weight: $checkedConvert('show_weight', (v) => v as bool),
          persons_can_edit: $checkedConvert('persons_can_edit',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          purItems: $checkedConvert(
              'purItems',
              (v) => (v as List<dynamic>)
                  .map((e) => PurItemDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$EditPurchaseDtoToJson(EditPurchaseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'room': instance.room,
      'message': instance.message,
      'show_pgroup': instance.show_pgroup,
      'show_price': instance.show_price,
      'show_qnty': instance.show_qnty,
      'show_weight': instance.show_weight,
      'persons_can_edit': instance.persons_can_edit,
      'purItems': instance.purItems.map((e) => e.toJson()).toList(),
    };
