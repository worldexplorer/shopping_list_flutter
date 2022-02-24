// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomsDto _$RoomsDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'RoomsDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['rooms'],
        );
        final val = RoomsDto(
          rooms: $checkedConvert(
              'rooms',
              (v) => (v as List<dynamic>)
                  .map((e) => RoomDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$RoomsDtoToJson(RoomsDto instance) => <String, dynamic>{
      'rooms': instance.rooms.map((e) => e.toJson()).toList(),
    };
