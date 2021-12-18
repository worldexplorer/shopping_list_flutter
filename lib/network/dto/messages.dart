import 'package:json_annotation/json_annotation.dart';

part 'messages.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class Message {
  String socketId;
  int userId;
  String username;
  String message;
  DateTime timestamp;

  Message({
    required this.socketId,
    required this.userId,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: false,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class Messages {
  List<Message> messages;

  Messages({required this.messages});

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);
// Map<String, dynamic> toJson() => _$MessagesToJson(this);
}
