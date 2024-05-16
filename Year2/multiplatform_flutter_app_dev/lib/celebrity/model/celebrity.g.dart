// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'celebrity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Celebrity _$CelebrityFromJson(Map<String, dynamic> json) => Celebrity(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDay: DateTime.parse(json['birthDay'] as String),
      died:
          json['died'] == null ? null : DateTime.parse(json['died'] as String),
      about: json['about'] as String,
      avatar: json['avatar'] as String,
      movieIdsWithRole: (json['movieIdsWithRole'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, $enumDecode(_$RoleEnumMap, e)),
              ))
          .toList(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$CelebrityToJson(Celebrity instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthDay': instance.birthDay.toIso8601String(),
      'died': instance.died?.toIso8601String(),
      'about': instance.about,
      'avatar': instance.avatar,
      'movieIdsWithRole': instance.movieIdsWithRole
          ?.map((e) => e.map((k, e) => MapEntry(k, _$RoleEnumMap[e]!)))
          .toList(),
      'id': instance.id,
    };

const _$RoleEnumMap = {
  Role.actor: 'actor',
  Role.producer: 'producer',
  Role.director: 'director',
  Role.cameraman: 'cameraman',
  Role.cgi: 'cgi',
  Role.music: 'music',
  Role.scriptwriter: 'scriptwriter',
};
