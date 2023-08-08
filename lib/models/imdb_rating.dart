class ImdbRating {
  final double? imdbRate;
  final int? imdbVotes;

  const ImdbRating({this.imdbRate, this.imdbVotes});

  Map<String, dynamic> toJson() => {
    'rating': {
      'star': imdbRate,
      'count': imdbVotes,
    },
  };

  factory ImdbRating.fromJson(Map<String, dynamic> jsonMap) {
    var rating = jsonMap['rating'];
    return ImdbRating(
      imdbRate: rating['star'],
      imdbVotes: rating['count'],
    );
  }
}