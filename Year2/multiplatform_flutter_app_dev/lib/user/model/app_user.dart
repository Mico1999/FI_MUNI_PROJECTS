import 'package:json_annotation/json_annotation.dart';
import 'package:movie_catalog/common/model/serializable.dart';
import 'package:movie_catalog/user/model/role.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser extends Serializable {
  final String userEmail;
  final Role role;
  final List<String>? favoriteMovies;
  final List<String>? favoriteCelebrities;
  final String? id;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  AppUser(
      {required this.userEmail,
      required this.role,
      required this.favoriteMovies,
      required this.favoriteCelebrities,
      required this.id});

  AppUser copyWith(
      {String? userEmail,
      Role? role,
      List<String>? favoriteMovies,
      List<String>? favoriteCelebrities,
      String? id}) {
    return AppUser(
        userEmail: userEmail ?? this.userEmail,
        role: role ?? this.role,
        favoriteMovies: favoriteMovies ?? this.favoriteMovies,
        favoriteCelebrities: favoriteCelebrities ?? this.favoriteCelebrities,
        id: id ?? this.id);
  }
}
