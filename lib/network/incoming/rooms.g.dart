// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Room',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'name', 'users'],
        );
        final val = Room(
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => v as int),
          users: $checkedConvert(
              'users',
              (v) => (v as List<dynamic>)
                  .map((e) => User.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Rooms _$RoomsFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Rooms',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['rooms'],
        );
        final val = Rooms(
          rooms: $checkedConvert(
              'rooms',
              (v) => (v as List<dynamic>)
                  .map((e) => Room.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );
