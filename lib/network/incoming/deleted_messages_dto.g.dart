// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_messages_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletedMessagesDto _$DeletedMessagesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeletedMessagesDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['messageIds'],
        );
        final val = DeletedMessagesDto(
          messageIds: $checkedConvert('messageIds',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$DeletedMessagesDtoToJson(DeletedMessagesDto instance) =>
    <String, dynamic>{
      'messageIds': instance.messageIds,
    };
