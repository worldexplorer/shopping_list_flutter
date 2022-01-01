// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_messages_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteMessagesDto _$DeleteMessagesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeleteMessagesDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['messageIds', 'user'],
        );
        final val = DeleteMessagesDto(
          messageIds: $checkedConvert('messageIds',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          user: $checkedConvert('user', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$DeleteMessagesDtoToJson(DeleteMessagesDto instance) =>
    <String, dynamic>{
      'messageIds': instance.messageIds,
      'user': instance.user,
    };
