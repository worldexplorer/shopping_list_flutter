// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'room_member_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: false,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class RoomMemberDto {
  int person;
  String? person_name;
  bool can_edit;
  bool can_invite;

  RoomMemberDto(
      {required this.person,
      this.person_name,
      required this.can_edit,
      required this.can_invite});

  // factory RoomMemberDto.fromJson(Map<String, dynamic> json) =>
  //     _$RoomMemberDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RoomMemberDtoToJson(this);
}