// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_needs_code_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationNeedsCodeDto _$RegistrationNeedsCodeDtoFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'RegistrationNeedsCodeDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['emailSent', 'smsSent', 'status'],
        );
        final val = RegistrationNeedsCodeDto(
          status: $checkedConvert('status', (v) => v as String),
          emailSent: $checkedConvert('emailSent', (v) => v as bool),
          smsSent: $checkedConvert('smsSent', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$RegistrationNeedsCodeDtoToJson(
        RegistrationNeedsCodeDto instance) =>
    <String, dynamic>{
      'emailSent': instance.emailSent,
      'smsSent': instance.smsSent,
      'status': instance.status,
    };
