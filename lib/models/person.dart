import 'dart:io' show File;
import 'cast.dart';
import 'crew.dart';

class Person {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final String creditId;
  Future<File?>? fProfile;

  Person({
    this.adult = false,
    required this.gender,
    required this.id,
    this.knownForDepartment = '',
    required this.name,
    required this.originalName,
    this.popularity = 0.0,
    this.profilePath,
    required this.creditId,
  });

  String get job {
    return this is Crew ? (this as Crew).job : (this as Cast).character;
  }

  Map<String, dynamic> toJson() => {
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

  factory Person.fromJson(Map<String, dynamic> jsonMap) {
    return Person(
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
