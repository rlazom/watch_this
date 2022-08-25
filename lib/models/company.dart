import 'dart:io' show File;

class Company {
  final int id;
  final String name;
  final String? description;
  final String? logoPath;
  final String originCountry;
  final int? parentCompany;
  final String? homepage;
  final String? headquarters;
  Future<File?>? fLogo;

  Company({
    required this.id,
    required this.name,
    this.description,
    this.logoPath,
    required this.originCountry,
    this.parentCompany,
    this.homepage,
    this.headquarters,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'logo_path': logoPath,
        'origin_country': originCountry,
        'parent_company': parentCompany,
        'homepage': homepage,
        'headquarters': headquarters,
      };

  factory Company.fromJson(Map<String, dynamic> jsonMap) {
    return Company(
      id: jsonMap['id'],
      name: jsonMap['name'],
      description: jsonMap['description'],
      logoPath: jsonMap['logo_path'],
      originCountry: jsonMap['origin_country'],
      parentCompany: jsonMap['parent_company'],
      homepage: jsonMap['homepage'],
      headquarters: jsonMap['headquarters'],
    );
  }
}
