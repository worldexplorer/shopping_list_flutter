import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list_flutter/network/dto/user.dart';

part 'rooms.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: false,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class Room {
  int id;
  String name;
  List<User> users;

  Room({required this.name, required this.id, required this.users});
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  // Map<String, dynamic> toJson() => _$RoomToJson(this);
}

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: false,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class Rooms {
  List<Room> rooms;

  Rooms({required this.rooms});

  factory Rooms.fromJson(Map<String, dynamic> json) => _$RoomsFromJson(json);
  // Map<String, dynamic> toJson() => _$RoomsToJson(this);
}
