// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      userEmail: json['userEmail'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      favoriteMovies: (json['favoriteMovies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      favoriteCelebrities: (json['favoriteCelebrities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'userEmail': instance.userEmail,
      'role': _$RoleEnumMap[instance.role]!,
      'favoriteMovies': instance.favoriteMovies,
      'favoriteCelebrities': instance.favoriteCelebrities,
      'id': instance.id,
    };

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.registered: 'registered',
};
