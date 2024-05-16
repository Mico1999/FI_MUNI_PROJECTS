// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      title: json['title'] as String,
      year: DateTime.parse(json['year'] as String),
      preview: json['preview'] as String,
      storyLine: json['storyLine'] as String,
      genreIds: (json['genreIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bannerImage: json['bannerImage'] as String,
      posterImage: json['posterImage'] as String,
      celebrityIdsWithRole: (json['celebrityIdsWithRole'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, $enumDecode(_$RoleEnumMap, e)),
              ))
          .toList(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'title': instance.title,
      'year': instance.year.toIso8601String(),
      'preview': instance.preview,
      'storyLine': instance.storyLine,
      'genreIds': instance.genreIds,
      'bannerImage': instance.bannerImage,
      'posterImage': instance.posterImage,
      'celebrityIdsWithRole': instance.celebrityIdsWithRole
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
