// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Message',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'username', 'message', 'timestamp'],
        );
        final val = Message(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
          timestamp:
              $checkedConvert('timestamp', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
    };

Messages _$MessagesFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Messages',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['messages'],
        );
        final val = Messages(
          messages: $checkedConvert(
              'messages',
              (v) => (v as List<dynamic>)
                  .map((e) => Message.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );
