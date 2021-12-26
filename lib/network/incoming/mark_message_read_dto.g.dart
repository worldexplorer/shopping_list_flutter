// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_message_read_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkMessageReadDto _$MarkMessageReadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MarkMessageReadDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['message', 'user'],
        );
        final val = MarkMessageReadDto(
          message: $checkedConvert('message', (v) => v as int),
          user: $checkedConvert('user', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$MarkMessageReadDtoToJson(MarkMessageReadDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
    };

UpdatedMessageReadDto _$UpdatedMessageReadDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdatedMessageReadDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'persons_read'],
        );
        final val = UpdatedMessageReadDto(
          id: $checkedConvert('id', (v) => v as int),
          persons_read: $checkedConvert('persons_read',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdatedMessageReadDtoToJson(
        UpdatedMessageReadDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'persons_read': instance.persons_read,
    };
