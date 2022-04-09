// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseDto _$PurchaseDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PurchaseDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'name',
            'room',
            'message',
            'show_pgroup',
            'show_serno',
            'show_qnty',
            'show_price',
            'show_weight',
            'show_state_unknown',
            'show_state_stop',
            'show_state_halfdone',
            'show_state_question',
            'persons_can_edit',
            'persons_can_fill',
            'id',
            'purItems',
            'date_created',
            'date_updated',
            'replyto_id',
            'copiedfrom_id',
            'person_created',
            'person_created_name',
            'purchased',
            'person_purchased',
            'person_purchased_name',
            'price_total',
            'weight_total'
          ],
        );
        final val = PurchaseDto(
          id: $checkedConvert('id', (v) => v),
          date_created: $checkedConvert(
              'date_created', (v) => DateTime.parse(v as String)),
          date_updated: $checkedConvert(
              'date_updated', (v) => DateTime.parse(v as String)),
          name: $checkedConvert('name', (v) => v),
          room: $checkedConvert('room', (v) => v),
          message: $checkedConvert('message', (v) => v),
          show_pgroup: $checkedConvert('show_pgroup', (v) => v),
          show_serno: $checkedConvert('show_serno', (v) => v),
          show_qnty: $checkedConvert('show_qnty', (v) => v),
          show_price: $checkedConvert('show_price', (v) => v),
          show_weight: $checkedConvert('show_weight', (v) => v),
          show_state_unknown: $checkedConvert('show_state_unknown', (v) => v),
          show_state_stop: $checkedConvert('show_state_stop', (v) => v),
          show_state_halfdone: $checkedConvert('show_state_halfdone', (v) => v),
          show_state_question: $checkedConvert('show_state_question', (v) => v),
          replyto_id: $checkedConvert('replyto_id', (v) => v),
          copiedfrom_id: $checkedConvert('copiedfrom_id', (v) => v),
          person_created: $checkedConvert('person_created', (v) => v as int),
          person_created_name:
              $checkedConvert('person_created_name', (v) => v as String),
          persons_can_edit: $checkedConvert('persons_can_edit', (v) => v),
          persons_can_fill: $checkedConvert('persons_can_fill', (v) => v),
          purchased: $checkedConvert('purchased', (v) => v as bool),
          person_purchased:
              $checkedConvert('person_purchased', (v) => v as int?),
          person_purchased_name:
              $checkedConvert('person_purchased_name', (v) => v as String?),
          price_total:
              $checkedConvert('price_total', (v) => (v as num?)?.toDouble()),
          weight_total:
              $checkedConvert('weight_total', (v) => (v as num?)?.toDouble()),
          purItems: $checkedConvert('purItems', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$PurchaseDtoToJson(PurchaseDto instance) =>
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
      'id': instance.id,
      'purItems': instance.purItems.map((e) => e.toJson()).toList(),
      'date_created': instance.date_created.toIso8601String(),
      'date_updated': instance.date_updated.toIso8601String(),
      'replyto_id': instance.replyto_id,
      'copiedfrom_id': instance.copiedfrom_id,
      'person_created': instance.person_created,
      'person_created_name': instance.person_created_name,
      'purchased': instance.purchased,
      'person_purchased': instance.person_purchased,
      'person_purchased_name': instance.person_purchased_name,
      'price_total': instance.price_total,
      'weight_total': instance.weight_total,
    };
