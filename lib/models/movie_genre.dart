class MovieGenre {
  final int id;
  final String? name;

  MovieGenre({required this.id, this.name});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  factory MovieGenre.fromJson(Map<String, dynamic> jsonMap) {
    return MovieGenre(
      id: jsonMap['id'],
      name: jsonMap['name'],
    );
  }
}
