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
          allowedKeys: const ['id', 'room', 'content'],
        );
        final val = EditMessageDto(
          id: $checkedConvert('id', (v) => v as int),
          room: $checkedConvert('room', (v) => v as int),
          content: $checkedConvert('content', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$EditMessageDtoToJson(EditMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room': instance.room,
      'content': instance.content,
    };
