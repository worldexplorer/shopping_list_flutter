// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: false,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class RegisterDto {
  String email;
  String phone;

  RegisterDto({required this.email, required this.phone});

  // factory LoginDto.fromJson(Map<String, dynamic> json) => _$RegisterDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);
}
