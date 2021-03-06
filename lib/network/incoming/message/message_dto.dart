// DTO regenerated by https://pub.dev/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
// $ flutter pub run build_runner build --delete-conflicting-outputs
// $ flutter pub run build_runner watch

import 'package:json_annotation/json_annotation.dart';

import '../purchase/purchase_dto.dart';

part 'message_dto.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class MessageDto {
  int id;
  DateTime date_created;
  DateTime date_updated;

  String content;
  bool edited;

  int? replyto_id;
  int? forwardfrom_id;

  List<int> persons_sent;
  List<int> persons_read;

  int room;
  int user;
  String user_name;

  int? purchaseId;
  PurchaseDto? purchase;

  MessageDto({
    required this.id,
    required this.date_created,
    required this.date_updated,
    required this.content,
    required this.room,
    required this.edited,
    required this.replyto_id,
    required this.forwardfrom_id,
    required this.persons_sent,
    required this.persons_read,
    required this.user,
    required this.user_name,
    required this.purchaseId,
    required this.purchase,
  });

  MessageDto clone() {
    return MessageDto.fromJson(toJson());
  }

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}
