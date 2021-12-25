// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditMessageDto _$EditMessageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'EditMessageDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'content', 'purchase'],
        );
        final val = EditMessageDto(
          id: $checkedConvert('id', (v) => v as int),
          content: $checkedConvert('content', (v) => v as String),
          purchase: $checkedConvert(
              'purchase',
              (v) => v == null
                  ? null
                  : PurchaseDto.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$EditMessageDtoToJson(EditMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'purchase': instance.purchase?.toJson(),
    };
