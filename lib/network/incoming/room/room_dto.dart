// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

import '../person/person_dto.dart';

part 'room_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class RoomDto {
  int id;
  String name;
  List<PersonDto> persons;
  List<int> canEdit;
  List<int> canInvite;
  // List<RoomMemberDto> members;

  RoomDto(
      {required this.name,
      required this.id,
      required this.persons,
      required this.canEdit,
      required this.canInvite});
  factory RoomDto.fromJson(Map<String, dynamic> json) =>
      _$RoomDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RoomDtoToJson(this);
}
