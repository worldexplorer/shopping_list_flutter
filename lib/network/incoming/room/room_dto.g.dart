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
          allowedKeys: const ['id', 'name', 'persons', 'canEdit', 'canInvite'],
        );
        final val = RoomDto(
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => v as int),
          persons: $checkedConvert(
              'persons',
              (v) => (v as List<dynamic>)
                  .map((e) => PersonDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
          canEdit: $checkedConvert('canEdit',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          canInvite: $checkedConvert('canInvite',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$RoomDtoToJson(RoomDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'persons': instance.persons.map((e) => e.toJson()).toList(),
      'canEdit': instance.canEdit,
      'canInvite': instance.canInvite,
    };
