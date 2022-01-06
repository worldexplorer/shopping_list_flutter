// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewMessageDto _$NewMessageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NewMessageDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['room', 'content', 'replyto_id'],
        );
        final val = NewMessageDto(
          room: $checkedConvert('room', (v) => v as int),
          content: $checkedConvert('content', (v) => v as String),
          replyto_id: $checkedConvert('replyto_id', (v) => v as int?),
        );
        return val;
      },
    );

Map<String, dynamic> _$NewMessageDtoToJson(NewMessageDto instance) =>
    <String, dynamic>{
      'room': instance.room,
      'content': instance.content,
      'replyto_id': instance.replyto_id,
    };
