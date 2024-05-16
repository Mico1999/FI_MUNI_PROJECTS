import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_catalog/common/model/serializable.dart';

part 'celebrity.g.dart';

@JsonSerializable()
class Celebrity extends Serializable {
  final String firstName;
  final String lastName;
  final DateTime birthDay;
  final DateTime? died;
  final String about;
  final String avatar;
  final List<Map<String, Role>>? movieIdsWithRole;
  final String? id;

  factory Celebrity.fromJson(Map<String, dynamic> json) =>
      _$CelebrityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CelebrityToJson(this);

  Celebrity(
      {required this.firstName,
      required this.lastName,
      required this.birthDay,
      required this.died,
      required this.about,
      required this.avatar,
      required this.movieIdsWithRole,
      required this.id});
}
