// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_message_read_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkMessageReadDto _$MarkMessageReadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MarkMessageReadDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['message', 'user'],
        );
        final val = MarkMessageReadDto(
          message: $checkedConvert('message', (v) => v as int),
          user: $checkedConvert('user', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$MarkMessageReadDtoToJson(MarkMessageReadDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
    };
