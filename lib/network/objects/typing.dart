import 'package:json_annotation/json_annotation.dart';

part 'typing.g.dart';

@JsonSerializable()
class Typing {
  String id;
  String username;
  bool typing;

  Typing({required this.id, required this.username, required this.typing});

  factory Typing.fromJson(Map<String, dynamic> json) => _$TypingFromJson(json);
  Map<String, dynamic> toJson() => _$TypingToJson(this);
}
