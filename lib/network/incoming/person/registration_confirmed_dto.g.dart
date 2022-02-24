// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_confirmed_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationConfirmedDto _$RegistrationConfirmedDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'RegistrationConfirmedDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['auth', 'status'],
        );
        final val = RegistrationConfirmedDto(
          auth: $checkedConvert('auth', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$RegistrationConfirmedDtoToJson(
        RegistrationConfirmedDto instance) =>
    <String, dynamic>{
      'auth': instance.auth,
      'status': instance.status,
    };
