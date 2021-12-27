// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_message_read_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
