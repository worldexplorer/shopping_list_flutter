// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_messages_read_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedMessagesReadDto _$UpdatedMessagesReadDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdatedMessagesReadDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['messagesUpdated'],
        );
        final val = UpdatedMessagesReadDto(
          messagesUpdated: $checkedConvert(
              'messagesUpdated',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      UpdatedMessageReadDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdatedMessagesReadDtoToJson(
        UpdatedMessagesReadDto instance) =>
    <String, dynamic>{
      'messagesUpdated':
          instance.messagesUpdated.map((e) => e.toJson()).toList(),
    };

UpdatedMessageReadDto _$UpdatedMessageReadDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdatedMessageReadDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'persons_read', 'room'],
        );
        final val = UpdatedMessageReadDto(
          id: $checkedConvert('id', (v) => v as int),
          persons_read: $checkedConvert('persons_read',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          room: $checkedConvert('room', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdatedMessageReadDtoToJson(
        UpdatedMessageReadDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'persons_read': instance.persons_read,
      'room': instance.room,
    };
