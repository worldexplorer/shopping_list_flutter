// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'registration_confirmed_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class RegistrationConfirmedDto {
  String auth;
  String status;

  RegistrationConfirmedDto({required this.auth, required this.status});

  factory RegistrationConfirmedDto.fromJson(Map<String, dynamic> json) =>
      _$RegistrationConfirmedDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RegistrationConfirmedDtoToJson(this);
}
