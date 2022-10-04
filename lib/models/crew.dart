import 'person.dart';

class Crew extends Person {
  final String department;
  @override
  String? job;

  Crew({
    required this.department,
    required this.job,
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
    'department': department,
    'job': job,
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

  factory Crew.fromJson(Map<String, dynamic> jsonMap) {
    return Crew(
      department: jsonMap['department'],
      job: jsonMap['job'],
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