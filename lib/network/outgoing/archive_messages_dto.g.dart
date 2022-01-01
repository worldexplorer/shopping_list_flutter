// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_messages_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveMessagesDto _$ArchiveMessagesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ArchiveMessagesDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['messageIds', 'archived', 'user'],
        );
        final val = ArchiveMessagesDto(
          messageIds: $checkedConvert('messageIds',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          archived: $checkedConvert('archived', (v) => v as bool),
          user: $checkedConvert('user', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$ArchiveMessagesDtoToJson(ArchiveMessagesDto instance) =>
    <String, dynamic>{
      'messageIds': instance.messageIds,
      'archived': instance.archived,
      'user': instance.user,
    };
