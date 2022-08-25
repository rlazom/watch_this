import 'person.dart';

class Cast extends Person {
  final int castId;
  String character;
  final int order;

  Cast({
    required this.castId,
    required this.character,
    required this.order,
    super.adult,
    required super.gender,
    required super.id,
    super.knownForDepartment,
    required super.name,
    required super.originalName,
    super.popularity,
    super.profilePath,
    required super.creditId,
  });

  Map<String, dynamic> toJson() => {
    'cast_id': castId,
    'character': character,
    'order': order,
    'adult': adult,
    'gender': gender,
    'id': id,
    'known_for_department': knownForDepartment,
    'name': name,
    'original_name': originalName,
    'popularity': popularity,
    'profile_path': profilePath,
    'credit_id': creditId,
  };

  factory Cast.fromJson(Map<String, dynamic> jsonMap) {
    return Cast(
      castId: jsonMap['cast_id'],
      character: jsonMap['character'],
      order: jsonMap['order'],
      adult: jsonMap['adult'],
      gender: jsonMap['gender'],
      id: jsonMap['id'],
      knownForDepartment: jsonMap['known_for_department'],
      name: jsonMap['name'],
      originalName: jsonMap['original_name'],
      popularity: jsonMap['popularity'],
      profilePath: jsonMap['profile_path'],
      creditId: jsonMap['credit_id'],
    );
  }
}