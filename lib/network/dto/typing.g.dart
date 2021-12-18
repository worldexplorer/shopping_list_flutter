// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Typing _$TypingFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Typing',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['socketId', 'userName', 'typing'],
        );
        final val = Typing(
          socketId: $checkedConvert('socketId', (v) => v as String),
          userName: $checkedConvert('userName', (v) => v as String),
          typing: $checkedConvert('typing', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$TypingToJson(Typing instance) => <String, dynamic>{
      'socketId': instance.socketId,
      'userName': instance.userName,
      'typing': instance.typing,
    };
