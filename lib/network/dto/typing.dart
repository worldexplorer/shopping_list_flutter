import 'package:json_annotation/json_annotation.dart';

part 'typing.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class Typing {
  String socketId;
  String userName;
  bool typing;

  Typing(
      {required this.socketId, required this.userName, required this.typing});

  factory Typing.fromJson(Map<String, dynamic> json) => _$TypingFromJson(json);
  Map<String, dynamic> toJson() => _$TypingToJson(this);
}
