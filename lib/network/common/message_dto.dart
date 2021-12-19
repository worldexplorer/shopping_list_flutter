// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

import 'purchase_dto.dart';
part 'message_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class MessageDto {
  int? id;
  DateTime date_created;
  DateTime date_updated;

  String content;
  int room;
  int user;
  String user_name;

  int? purchaseId;
  PurchaseDto? purchase;

  MessageDto({
    this.id,
    required this.date_created,
    required this.date_updated,
    required this.content,
    required this.room,
    required this.user,
    required this.user_name,
    required this.purchaseId,
    required this.purchase,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}
