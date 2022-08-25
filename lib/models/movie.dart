import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show File;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:watch_this/models/company.dart';
import 'package:watch_this/models/watch_provider.dart';

import 'production_country.dart';
import 'movie_genre.dart';

final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

class Movie implements Comparable<Movie> {
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
  final DateTime? releaseDate;
  final String? status;
  final double voteAverage;
  final int voteCount;
  String? character;
  final String? job;
  final String? backdropPath;
  final String? posterPath;
  final Map? watchProviders;
  final List<WatchProvider>? watchProvidersList;
  final Map? releaseDates;
  final List<String>? certifications;
  final Map? similar;
  final List<Movie>? similarMovies;
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
    this.releaseDate,
    this.status,
    this.voteAverage = 0.0,
    required this.voteCount,
    this.character,
    this.job,
    this.backdropPath,
    required this.posterPath,
    this.watchProviders,
    this.watchProvidersList,
    this.releaseDates,
    this.certifications,
    this.similar,
    this.similarMovies,
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
        'release_date':
            (releaseDate == null || releaseDate.toString().trim() == '')
                ? null
                : dateFormat.format(releaseDate!),
        'status': status,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'character': character,
        'job': job,
        'backdrop_path': backdropPath,
        'poster_path': posterPath,
        'watch/providers': watchProviders,
        'release_dates': releaseDates,
        'recommendations': similar,
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

    List<WatchProvider>? tWatchProviders = [];
    if (jsonMap['watch/providers'] != null) {
      Map providersMap = jsonMap['watch/providers']['results'];

      for (String locale in providersMap.keys) {
        Map typesMap = providersMap[locale];
        for (String type in typesMap.keys) {
          if (type != 'link') {
            List originList = typesMap[type] as List;
            List<WatchProvider> tProviders = originList
                .map((e) =>
                    WatchProvider.fromJson(e, locale: locale, type: type))
                .toList();
            tWatchProviders.addAll(tProviders);
          }
        }
      }
    }

    Set<String>? certificationsUnique;
    if (jsonMap['release_dates'] != null) {
      List releases = jsonMap['release_dates']['results'];

      Map? releaseUS = releases.firstWhereOrNull(
          (element) => element['iso_3166_1'].toString().toUpperCase() == 'US');

      if (releaseUS != null) {
        List tReleases = releaseUS['release_dates'] as List;
        certificationsUnique =
            Set.from(tReleases.map((e) => e['certification']));
        certificationsUnique.removeWhere((element) => element.trim() == '');
      }
    }

    DateTime? releaseDateDt;
    if (jsonMap['release_date'] != null &&
        jsonMap['release_date'].toString().trim() != '') {
      releaseDateDt = dateFormat.parse(jsonMap['release_date']);
    }

    List<Movie>? tSimilarMovies = jsonMap['recommendations'] == null
        ? null
        : (jsonMap['recommendations']['results'] as List)
            .map((e) => Movie.fromJson(e))
            .toList();

    Duration? runtimeDr = jsonMap['runtime'] == null
        ? null
        : Duration(minutes: jsonMap['runtime']);

    double? tBudget = jsonMap['budget'] == null
        ? null
        : double.parse(jsonMap['budget'].toString());
    double? tRevenue = jsonMap['revenue'] == null
        ? null
        : double.parse(jsonMap['revenue'].toString());

    double tVoteAverage = jsonMap['vote_average'] == null
        ? 0.0
        : double.parse(jsonMap['vote_average'].toString());

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
      voteAverage: tVoteAverage,
      voteCount: jsonMap['vote_count'],
      character: jsonMap['character'],
      job: jsonMap['job'],
      backdropPath: jsonMap['backdrop_path'],
      posterPath: jsonMap['poster_path'],
      watchProviders: jsonMap['watch/providers'],
      watchProvidersList:
          tWatchProviders.isEmpty ? null : tWatchProviders.toSet().toList(),
      releaseDates: jsonMap['release_dates'],
      certifications: certificationsUnique?.toList(),
      similar: jsonMap['recommendations'],
      similarMovies: tSimilarMovies,
    );
  }

  @override
  String toString() {
    return 'id: $id, title: $title';
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is Movie && other.id == id && other.title == title;
  }

  @override
  int compareTo(Movie other) {
    int r = other.voteAverage.compareTo(voteAverage);
    if (r != 0) return r;
    return (other.popularity).compareTo((popularity));
  }

  /// Allowed Values: Rumored, Planned, In Production, Post Production, Released, Canceled
  IconData? getStatusIcon() {
    switch (status) {
      case 'Rumored': // Enter this block if mark == 0
        return Icons.message_outlined;
      case 'Planned':
        return Icons.assignment_outlined;
      case 'In Production':
        return Icons.settings_outlined;
      case 'Post Production':
        return Icons.settings_suggest_outlined;
      case 'Canceled':
        return Icons.cancel_outlined;
      default:
        return null;
    }
  }
}
