// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_pur_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewPurItemDto _$NewPurItemDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NewPurItemDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'name',
            'qnty',
            'comment',
            'pgroup_id',
            'pgroup_name',
            'product_id',
            'product_name',
            'punit_id',
            'punit_name',
            'punit_brief',
            'punit_fpoint'
          ],
        );
        final val = NewPurItemDto(
          name: $checkedConvert('name', (v) => v as String),
          qnty: $checkedConvert('qnty', (v) => (v as num?)?.toDouble()),
          comment: $checkedConvert('comment', (v) => v as String?),
          pgroup_id: $checkedConvert('pgroup_id', (v) => v as int?),
          pgroup_name: $checkedConvert('pgroup_name', (v) => v as String?),
          product_id: $checkedConvert('product_id', (v) => v as int?),
          product_name: $checkedConvert('product_name', (v) => v as String?),
          punit_id: $checkedConvert('punit_id', (v) => v as int?),
          punit_name: $checkedConvert('punit_name', (v) => v as String?),
          punit_brief: $checkedConvert('punit_brief', (v) => v as String?),
          punit_fpoint: $checkedConvert('punit_fpoint', (v) => v as bool?),
        );
        return val;
      },
    );

Map<String, dynamic> _$NewPurItemDtoToJson(NewPurItemDto instance) =>
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
    };
