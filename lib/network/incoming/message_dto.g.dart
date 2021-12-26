// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'MessageDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'id',
            'date_created',
            'date_updated',
            'content',
            'edited',
            'replyto_id',
            'forwardfrom_id',
            'persons_sent',
            'persons_read',
            'room',
            'user',
            'user_name',
            'purchaseId',
            'purchase'
          ],
        );
        final val = MessageDto(
          id: $checkedConvert('id', (v) => v as int),
          date_created: $checkedConvert(
              'date_created', (v) => DateTime.parse(v as String)),
          date_updated: $checkedConvert(
              'date_updated', (v) => DateTime.parse(v as String)),
          content: $checkedConvert('content', (v) => v as String),
          room: $checkedConvert('room', (v) => v as int),
          edited: $checkedConvert('edited', (v) => v as bool),
          replyto_id: $checkedConvert('replyto_id', (v) => v as int?),
          forwardfrom_id: $checkedConvert('forwardfrom_id', (v) => v as int?),
          persons_sent: $checkedConvert('persons_sent',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          persons_read: $checkedConvert('persons_read',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          user: $checkedConvert('user', (v) => v as int),
          user_name: $checkedConvert('user_name', (v) => v as String),
          purchaseId: $checkedConvert('purchaseId', (v) => v as int?),
          purchase: $checkedConvert(
              'purchase',
              (v) => v == null
                  ? null
                  : PurchaseDto.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_created': instance.date_created.toIso8601String(),
      'date_updated': instance.date_updated.toIso8601String(),
      'content': instance.content,
      'edited': instance.edited,
      'replyto_id': instance.replyto_id,
      'forwardfrom_id': instance.forwardfrom_id,
      'persons_sent': instance.persons_sent,
      'persons_read': instance.persons_read,
      'room': instance.room,
      'user': instance.user,
      'user_name': instance.user_name,
      'purchaseId': instance.purchaseId,
      'purchase': instance.purchase?.toJson(),
    };
