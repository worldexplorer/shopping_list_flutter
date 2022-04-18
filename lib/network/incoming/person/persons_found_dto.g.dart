// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persons_found_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonsFoundDto _$PersonsFoundDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonsFoundDto',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['personsFound'],
        );
        final val = PersonsFoundDto(
          personsFound: $checkedConvert(
              'personsFound',
              (v) => (v as List<dynamic>)
                  .map((e) => PersonDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$PersonsFoundDtoToJson(PersonsFoundDto instance) =>
    <String, dynamic>{
      'personsFound': instance.personsFound.map((e) => e.toJson()).toList(),
    };
