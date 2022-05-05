// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomMemberDto _$RoomMemberDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RoomMemberDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'person',
            'person_name',
            'person_email',
            'person_phone',
            'person_color',
            'person_username',
            'can_edit',
            'can_invite'
          ],
        );
        final val = RoomMemberDto(
          person: $checkedConvert('person', (v) => v as int),
          person_name: $checkedConvert('person_name', (v) => v as String),
          person_email: $checkedConvert('person_email', (v) => v as String),
          person_phone: $checkedConvert('person_phone', (v) => v as String),
          person_color: $checkedConvert('person_color', (v) => v as String),
          person_username:
              $checkedConvert('person_username', (v) => v as String),
          can_edit: $checkedConvert('can_edit', (v) => v as bool),
          can_invite: $checkedConvert('can_invite', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$RoomMemberDtoToJson(RoomMemberDto instance) =>
    <String, dynamic>{
      'person': instance.person,
      'person_name': instance.person_name,
      'person_email': instance.person_email,
      'person_phone': instance.person_phone,
      'person_color': instance.person_color,
      'person_username': instance.person_username,
      'can_edit': instance.can_edit,
      'can_invite': instance.can_invite,
    };
