import 'package:json_annotation/json_annotation.dart';

/// Helper function used in generated code when
/// `JsonSerializableGenerator.checked` is `true`.
///
/// Should not be used directly.
void fillConverted<T>(
  Map<String, dynamic> json,
  String key,
  T Function(dynamic) castFunc, {
  Object? Function(Map, String)? readValue,
}) {
  try {
    json[key] = castFunc(readValue == null ? json[key] : readValue(json, key));
  } on CheckedFromJsonException {
    rethrow;
  } catch (e) {
    throw CheckedFromJsonException(
        json, key, T.runtimeType.toString(), e.toString());
  }
}
