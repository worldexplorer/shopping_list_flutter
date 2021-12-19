// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesDto _$MessagesDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'MessagesDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['room', 'messages', 'lastMessageId'],
        );
        final val = MessagesDto(
          room: $checkedConvert('room', (v) => v as int),
          messages: $checkedConvert(
              'messages',
              (v) => (v as List<dynamic>)
                  .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
          lastMessageId: $checkedConvert('lastMessageId', (v) => v as int),
        );
        return val;
      },
    );
