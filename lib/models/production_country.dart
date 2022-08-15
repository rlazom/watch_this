class ProductionCountry {
  final String iso3166_1;
  final String name;

  ProductionCountry({
    required this.iso3166_1,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'iso_3166_1': iso3166_1,
    'name': name,
  };

  factory ProductionCountry.fromJson(Map<String, dynamic> jsonMap) {
    return ProductionCountry(
      iso3166_1: jsonMap['iso_3166_1'],
      name: jsonMap['name'],
    );
  }
}
