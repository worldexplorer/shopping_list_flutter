// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'find_persons_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: false,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class FindPersonsDto {
  String keyword;
  int roomId;

  FindPersonsDto({required this.keyword, required this.roomId});

  // factory LoginDto.fromJson(Map<String, dynamic> json) => _$FindPersonsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FindPersonsDtoToJson(this);
}