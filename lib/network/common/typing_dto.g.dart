// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypingDto _$TypingDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TypingDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['socketId', 'userName', 'typing'],
        );
        final val = TypingDto(
          socketId: $checkedConvert('socketId', (v) => v as String),
          userName: $checkedConvert('userName', (v) => v as String),
          typing: $checkedConvert('typing', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$TypingDtoToJson(TypingDto instance) => <String, dynamic>{
      'socketId': instance.socketId,
      'userName': instance.userName,
      'typing': instance.typing,
    };
