// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archived_messages_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchivedMessagesDto _$ArchivedMessagesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ArchivedMessagesDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['messageIds'],
        );
        final val = ArchivedMessagesDto(
          messageIds: $checkedConvert('messageIds',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ArchivedMessagesDtoToJson(
        ArchivedMessagesDto instance) =>
    <String, dynamic>{
      'messageIds': instance.messageIds,
    };
