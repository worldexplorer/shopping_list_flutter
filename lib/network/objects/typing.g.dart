// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Typing _$TypingFromJson(Map<String, dynamic> json) => Typing(
      id: json['id'] as String,
      username: json['username'] as String,
      typing: json['typing'] as bool,
    );

Map<String, dynamic> _$TypingToJson(Typing instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'typing': instance.typing,
    };
