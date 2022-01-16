// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pur_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurItemDto _$PurItemDtoFromJson(Map<String, dynamic> json) => PurItemDto(
      name: json['name'],
      qnty: json['qnty'],
      comment: json['comment'],
      pgroup_id: json['pgroup_id'],
      pgroup_name: json['pgroup_name'],
      product_id: json['product_id'],
      product_name: json['product_name'],
      punit_id: json['punit_id'],
      punit_name: json['punit_name'],
      punit_brief: json['punit_brief'],
      punit_fpoint: json['punit_fpoint'],
      id: json['id'] as int,
      bought: json['bought'] as int,
      bought_qnty: (json['bought_qnty'] as num?)?.toDouble(),
      bought_price: (json['bought_price'] as num?)?.toDouble(),
      bought_weight: (json['bought_weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PurItemDtoToJson(PurItemDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'qnty': instance.qnty,
      'comment': instance.comment,
      'pgroup_id': instance.pgroup_id,
      'pgroup_name': instance.pgroup_name,
      'product_id': instance.product_id,
      'product_name': instance.product_name,
      'punit_id': instance.punit_id,
      'punit_name': instance.punit_name,
      'punit_brief': instance.punit_brief,
      'punit_fpoint': instance.punit_fpoint,
      'id': instance.id,
      'bought': instance.bought,
      'bought_qnty': instance.bought_qnty,
      'bought_price': instance.bought_price,
      'bought_weight': instance.bought_weight,
    };
