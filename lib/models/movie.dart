import 'package:intl/intl.dart';
import 'dart:io' show File;
import 'package:watch_this/models/company.dart';

import 'production_country.dart';
import 'movie_genre.dart';

final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

class Movie {
  final int id;
  final String? imdbId;
  final double? imdbRate;
  final bool adult;
  final Map? belongsToCollection;
  final double? budget;
  final double? revenue;
  final List<MovieGenre>? genres;
  final String? homepage;
  final String originalLanguage;
  final String title;
  final String originalTitle;
  final String overview;
  final String? tagline;
  final Duration? runtime;
  final double popularity;
  final List<Company>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final DateTime releaseDate;
  final String? status;
  final double voteAverage;
  final int voteCount;
  final String backdropPath;
  final String posterPath;
  Future<File?>? fPoster;
  Future<File?>? fBackdrop;

  Movie({
    required this.id,
    this.imdbId,
    this.imdbRate,
    required this.adult,
    this.belongsToCollection,
    this.budget,
    this.revenue,
    this.genres,
    this.homepage,
    required this.originalLanguage,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.tagline,
    this.runtime,
    required this.popularity,
    this.productionCompanies,
    this.productionCountries,
    required this.releaseDate,
    this.status,
    required this.voteAverage,
    required this.voteCount,
    required this.backdropPath,
    required this.posterPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'imdb_id': imdbId,
        'imdb_rate': imdbRate,
        'adult': adult,
        'belongs_to_collection': belongsToCollection,
        'budget': budget,
        'revenue': revenue,
        'genres': genres,
        'homepage': homepage,
        'original_language': originalLanguage,
        'title': title,
        'original_title': originalTitle,
        'overview': overview,
        'tagline': tagline,
        'runtime': runtime?.inMinutes,
        'popularity': popularity,
        'production_companies': productionCompanies,
        'production_countries': productionCountries,
        'release_date': dateFormat.format(releaseDate),
        'status': status,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'backdrop_path': backdropPath,
        'poster_path': posterPath,
      };

  factory Movie.fromJson(Map<String, dynamic> jsonMap) {
    // print('factory Movie.fromJson(id: ${jsonMap['id']} - title: ${jsonMap['title']})');
    // print('factory Movie.fromJson(jsonMap: $jsonMap');

    // List genresList = jsonMap['genres'] ?? jsonMap['genre_ids'];
    // List<MovieGenre>? tGenres;
    List<MovieGenre>? tGenres = jsonMap['genres'] == null
        ? null
        : (jsonMap['genres'] as List)
            .map((e) => MovieGenre.fromJson(e))
            .toList();

    // List<Company>? tCompanies;
    List<Company>? tCompanies = jsonMap['production_companies'] == null
        ? null
        : (jsonMap['production_companies'] as List)
            .map((e) => Company.fromJson(e))
            .toList();

    // List<ProductionCountry>? tProductionCountries;
    List<ProductionCountry>? tProductionCountries =
        jsonMap['production_countries'] == null
            ? null
            : (jsonMap['production_countries'] as List)
                .map((e) => ProductionCountry.fromJson(e))
                .toList();

    DateTime releaseDateDt = dateFormat.parse(jsonMap['release_date']);
    Duration? runtimeDr = jsonMap['runtime'] == null ? null : Duration(minutes: jsonMap['runtime']);

    double? tBudget = jsonMap['budget'] == null ? null : double.parse(jsonMap['budget'].toString());
    double? tRevenue = jsonMap['revenue'] == null ? null : double.parse(jsonMap['revenue'].toString());

    // print('RETURN - factory Movie.fromJson');
    return Movie(
        id: jsonMap['id'],
        imdbId: jsonMap['imdb_id'],
        imdbRate: jsonMap['imdb_rate'],
        adult: jsonMap['adult'],
        belongsToCollection: jsonMap['belongs_to_collection'],
        budget: tBudget,
        revenue: tRevenue,
        genres: tGenres,
        homepage: jsonMap['homepage'],
        originalLanguage: jsonMap['original_language'],
        title: jsonMap['title'],
        originalTitle: jsonMap['original_title'],
        overview: jsonMap['overview'],
        tagline: jsonMap['tagline'],
        runtime: runtimeDr,
        popularity: jsonMap['popularity'],
        productionCompanies: tCompanies,
        productionCountries: tProductionCountries,
        releaseDate: releaseDateDt,
        status: jsonMap['status'],
        voteAverage: jsonMap['vote_average'],
        voteCount: jsonMap['vote_count'],
        backdropPath: jsonMap['backdrop_path'],
        posterPath: jsonMap['poster_path']);
  }
}
