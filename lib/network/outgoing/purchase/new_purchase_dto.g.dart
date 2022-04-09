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
            'replyto_id',
            'copiedfrom_id',
            'newPurItems'
          ],
        );
        final val = NewPurchaseDto(
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
          replyto_id: $checkedConvert('replyto_id', (v) => v as int?),
          copiedfrom_id: $checkedConvert('copiedfrom_id', (v) => v as int?),
          persons_can_edit: $checkedConvert('persons_can_edit', (v) => v),
          persons_can_fill: $checkedConvert('persons_can_fill', (v) => v),
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
      'replyto_id': instance.replyto_id,
      'copiedfrom_id': instance.copiedfrom_id,
      'newPurItems': instance.newPurItems.map((e) => e.toJson()).toList(),
    };
