// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build --delete-conflicting-outputs
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'mark_message_read_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class MarkMessagesReadDto {
  List<int> messageIds;
  int user;

  MarkMessagesReadDto({required this.messageIds, required this.user});

  factory MarkMessagesReadDto.fromJson(Map<String, dynamic> json) =>
      _$MarkMessagesReadDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MarkMessagesReadDtoToJson(this);
}