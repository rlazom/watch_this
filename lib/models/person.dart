import 'dart:io' show File;
import 'package:watch_this/common/enums.dart';

import 'cast.dart';
import 'crew.dart';
import 'media.dart';

class Person extends Media {
  final int gender;
  final String knownForDepartment;
  final String name;
  final String? originalName;
  final double popularity;
  final String? profilePath;
  final String? creditId;
  Future<File?>? fProfile;

  Person({
    adult = false,
    mediaType = MediaType.person,
    required this.gender,
    required id,
    this.knownForDepartment = '',
    required this.name,
    this.originalName,
    this.popularity = 0.0,
    this.profilePath,
    this.creditId,
  }) : super(id: id, mediaType: mediaType, title: name, adult: adult);

  String? get job {
    return this is Crew ? (this as Crew).job : (this as Cast).character;
  }
  set job(String? newJob) {
    // this is Crew ? ((this as Crew).job += ' / $newJob') : ((this as Cast).character += ' / $newJob');
    if(this is Crew) {
      // (this as Crew).job += ' / $newJob';
      Crew crew = this as Crew;
      if(crew.job != null) {
        crew.job = '${crew.job} / $newJob';
      } else {
        crew.job = ' / $newJob';
      }
    } else {
      Cast cast = this as Cast;
      if(cast.character != null) {
        cast.character = '${cast.character} / $newJob';
      } else {
        cast.character = ' / $newJob';
      }
    }
  }

  @override
  String toString() {
    return name;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is Person &&
        other.id == id &&
        other.name == name;
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
