// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewPurchaseDto _$NewPurchaseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NewPurchaseDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'name',
            'room',
            'message',
            'show_pgroup',
            'show_qnty',
            'show_price',
            'show_weight',
            'show_threestate',
            'copiedfrom_id',
            'persons_can_edit',
            'newPurItems'
          ],
        );
        final val = NewPurchaseDto(
          name: $checkedConvert('name', (v) => v as String),
          room: $checkedConvert('room', (v) => v as int),
          message: $checkedConvert('message', (v) => v as int),
          show_pgroup: $checkedConvert('show_pgroup', (v) => v as bool),
          show_qnty: $checkedConvert('show_qnty', (v) => v as bool),
          show_price: $checkedConvert('show_price', (v) => v as bool),
          show_weight: $checkedConvert('show_weight', (v) => v as bool),
          show_threestate: $checkedConvert('show_threestate', (v) => v as bool),
          copiedfrom_id: $checkedConvert('copiedfrom_id', (v) => v as int?),
          persons_can_edit: $checkedConvert('persons_can_edit',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          newPurItems: $checkedConvert(
              'newPurItems',
              (v) => (v as List<dynamic>)
                  .map((e) => NewPurItemDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$NewPurchaseDtoToJson(NewPurchaseDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'room': instance.room,
      'message': instance.message,
      'show_pgroup': instance.show_pgroup,
      'show_qnty': instance.show_qnty,
      'show_price': instance.show_price,
      'show_weight': instance.show_weight,
      'show_threestate': instance.show_threestate,
      'copiedfrom_id': instance.copiedfrom_id,
      'persons_can_edit': instance.persons_can_edit,
      'newPurItems': instance.newPurItems.map((e) => e.toJson()).toList(),
    };
