// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_message_read_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkMessagesReadDto _$MarkMessagesReadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MarkMessagesReadDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['messageIds', 'user'],
        );
        final val = MarkMessagesReadDto(
          messageIds: $checkedConvert('messageIds',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          user: $checkedConvert('user', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$MarkMessagesReadDtoToJson(
        MarkMessagesReadDto instance) =>
    <String, dynamic>{
      'messageIds': instance.messageIds,
      'user': instance.user,
    };
