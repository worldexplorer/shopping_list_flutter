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
      'room': instance.room,
      'user': instance.user,
      'user_name': instance.user_name,
      'purchaseId': instance.purchaseId,
      'purchase': instance.purchase?.toJson(),
    };