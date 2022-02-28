// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewRoomDto _$NewRoomDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'NewRoomDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['name', 'userIds'],
        );
        final val = NewRoomDto(
          name: $checkedConvert('name', (v) => v as String),
          userIds: $checkedConvert('userIds',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$NewRoomDtoToJson(NewRoomDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userIds': instance.userIds,
    };
