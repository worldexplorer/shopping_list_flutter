// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomDto _$RoomDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'RoomDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'name', 'members'],
        );
        final val = RoomDto(
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => v as int),
          members: $checkedConvert(
              'members',
              (v) => (v as List<dynamic>)
                  .map((e) => RoomMemberDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$RoomDtoToJson(RoomDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
