// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_room_members_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$EditRoomMembersDtoToJson(EditRoomMembersDto instance) =>
    <String, dynamic>{
      'personEditing': instance.personEditing,
      'personEditing_name': instance.personEditing_name,
      'roomId': instance.roomId,
      'personsToChangePermissions':
          instance.personsToChangePermissions?.map((e) => e.toJson()).toList(),
      'personsToAdd': instance.personsToAdd?.map((e) => e.toJson()).toList(),
      'welcomeMsg': instance.welcomeMsg,
      'personsToRemove':
          instance.personsToRemove?.map((e) => e.toJson()).toList(),
      'goodByeMsg': instance.goodByeMsg,
    };
