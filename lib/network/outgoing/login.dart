import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable(
    checked: true,
    createFactory: false,
    createToJson: true,
    explicitToJson: true,
    disallowUnrecognizedKeys: true,
    includeIfNull: true)
class Login {
  String phone;

  Login({required this.phone});

  // factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
