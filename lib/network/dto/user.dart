import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: true,
    createToJson: false,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class User {
  int id;
  String name;
  String email;
  String phone;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  // Map<String, dynamic> toJson() => _$UserToJson(this);
}
