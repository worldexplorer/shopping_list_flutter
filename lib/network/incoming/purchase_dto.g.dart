// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseDto _$PurchaseDtoFromJson(Map<String, dynamic> json) => PurchaseDto(
      id: json['id'],
      date_created: DateTime.parse(json['date_created'] as String),
      date_updated: DateTime.parse(json['date_updated'] as String),
      name: json['name'],
      room: json['room'],
      message: json['message'],
      show_pgroup: json['show_pgroup'],
      show_serno: json['show_serno'],
      show_qnty: json['show_qnty'],
      show_price: json['show_price'],
      show_weight: json['show_weight'],
      show_state_unknown: json['show_state_unknown'],
      show_state_stop: json['show_state_stop'],
      replyto_id: json['replyto_id'],
      copiedfrom_id: json['copiedfrom_id'],
      person_created: json['person_created'] as int,
      person_created_name: json['person_created_name'] as String,
      persons_can_edit: json['persons_can_edit'],
      persons_can_fill: json['persons_can_fill'],
      purchased: json['purchased'] as bool,
      person_purchased: json['person_purchased'] as int?,
      person_purchased_name: json['person_purchased_name'] as String?,
      price_total: (json['price_total'] as num?)?.toDouble(),
      weight_total: (json['weight_total'] as num?)?.toDouble(),
      purItems: json['purItems'],
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
