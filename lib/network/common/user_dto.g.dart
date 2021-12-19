// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['id', 'name', 'email', 'phone'],
        );
        final val = UserDto(
          id: $checkedConvert('id', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          phone: $checkedConvert('phone', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };
