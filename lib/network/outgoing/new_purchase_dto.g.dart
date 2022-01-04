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
            'show_price',
            'show_qnty',
            'show_weight',
            'copiedfrom_id',
            'person_created',
            'person_created_name',
            'persons_can_edit',
            'purchased',
            'person_purchased',
            'person_purchased_name',
            'price_total',
            'weight_total',
            'purItems'
          ],
        );
        final val = NewPurchaseDto(
          name: $checkedConvert('name', (v) => v as String),
          room: $checkedConvert('room', (v) => v as int),
          message: $checkedConvert('message', (v) => v as int),
          show_pgroup: $checkedConvert('show_pgroup', (v) => v as bool),
          show_price: $checkedConvert('show_price', (v) => v as bool),
          show_qnty: $checkedConvert('show_qnty', (v) => v as bool),
          show_weight: $checkedConvert('show_weight', (v) => v as bool),
          copiedfrom_id: $checkedConvert('copiedfrom_id', (v) => v as int?),
          person_created: $checkedConvert('person_created', (v) => v as int),
          person_created_name:
              $checkedConvert('person_created_name', (v) => v as String),
          persons_can_edit: $checkedConvert('persons_can_edit',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          purchased: $checkedConvert('purchased', (v) => v as bool),
          person_purchased:
              $checkedConvert('person_purchased', (v) => v as int?),
          person_purchased_name:
              $checkedConvert('person_purchased_name', (v) => v as String?),
          price_total:
              $checkedConvert('price_total', (v) => (v as num?)?.toDouble()),
          weight_total:
              $checkedConvert('weight_total', (v) => (v as num?)?.toDouble()),
          purItems: $checkedConvert(
              'purItems',
              (v) => (v as List<dynamic>)
                  .map((e) => PurItemDto.fromJson(e as Map<String, dynamic>))
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
      'show_price': instance.show_price,
      'show_qnty': instance.show_qnty,
      'show_weight': instance.show_weight,
      'copiedfrom_id': instance.copiedfrom_id,
      'person_created': instance.person_created,
      'person_created_name': instance.person_created_name,
      'persons_can_edit': instance.persons_can_edit,
      'purchased': instance.purchased,
      'person_purchased': instance.person_purchased,
      'person_purchased_name': instance.person_purchased_name,
      'price_total': instance.price_total,
      'weight_total': instance.weight_total,
      'purItems': instance.purItems.map((e) => e.toJson()).toList(),
    };
