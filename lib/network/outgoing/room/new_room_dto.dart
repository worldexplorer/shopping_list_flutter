// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'new_room_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class NewRoomDto {
  String name;
  List<int> userIds;

  NewRoomDto({required this.name, required this.userIds});

  factory NewRoomDto.fromJson(Map<String, dynamic> json) =>
      _$NewRoomDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NewRoomDtoToJson(this);
}
