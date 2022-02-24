// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenameRoomDto _$RenameRoomDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RenameRoomDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'newName'],
        );
        final val = RenameRoomDto(
          id: $checkedConvert('id', (v) => v as int),
          newName: $checkedConvert('newName', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$RenameRoomDtoToJson(RenameRoomDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'newName': instance.newName,
    };
