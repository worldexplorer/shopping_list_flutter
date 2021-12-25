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
          allowedKeys: const ['room', 'user', 'content', 'purchase'],
        );
        final val = NewMessageDto(
          room: $checkedConvert('room', (v) => v as int),
          user: $checkedConvert('user', (v) => v as int),
          content: $checkedConvert('content', (v) => v as String),
          purchase: $checkedConvert(
              'purchase',
              (v) => v == null
                  ? null
                  : NewPurchaseDto.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$NewMessageDtoToJson(NewMessageDto instance) =>
    <String, dynamic>{
      'room': instance.room,
      'user': instance.user,
      'content': instance.content,
      'purchase': instance.purchase?.toJson(),
    };
