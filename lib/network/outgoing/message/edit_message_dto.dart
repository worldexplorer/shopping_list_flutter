// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build --delete-conflicting-outputs
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

part 'edit_message_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class EditMessageDto {
  int id;
  int room;
  String content;
  // PurchaseDto? purchase;

  EditMessageDto({
    required this.id,
    required this.room,
    required this.content,
    // this.purchase,
  });

  factory EditMessageDto.fromJson(Map<String, dynamic> json) =>
      _$EditMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$EditMessageDtoToJson(this);
}
