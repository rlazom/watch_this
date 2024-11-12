import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:watch_this/common/extensions.dart';
import 'package:watch_this/models/cast.dart';
import 'package:watch_this/models/crew.dart';
import 'package:watch_this/models/imdb_rating.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/movie_genre.dart';

import '../../../services/shared_preferences_service.dart';
import '../../r_master/data_sources/r_master_data_source_local.dart';

class MovieDataSourceLocal extends RMasterDataSourceLocal {
  final SharedPreferencesService _shared = SharedPreferencesService();

  MovieDataSourceLocal() : super();

  Future<Movie?> getExtendedMovieData(int movieId) async {
    // print('MovieDataSourceLocal - getExtendedMovieData()');
    Movie? result;
    var response = _shared.getExtendedMovieData(movieId);

    if (response != null) {
      result = Movie.fromJson(json.decode(response));
    }
    // print('RETURN MovieDataSourceLocal - getExtendedMovieData() - response == null [${response == null}]');
    return result;
  }

  Future<Map?> getMovieCreditsData(int movieId) async {
    // print('MovieDataSourceLocal - getMovieCreditsData()');
    List<Cast> cast = [];
    List<Crew> crew = [];
    Map<String, dynamic>? credits;
    var responseCast = _shared.getExtendedMovieCastData(movieId);
    var responseCrew = _shared.getExtendedMovieCrewData(movieId);

    if (responseCast != null) {
      List castJsonList = json.decode(responseCast) as List;
      cast = castJsonList.map((e) => Cast.fromJson(e)).toList();
    }
    if (responseCrew != null) {
      List crewJsonList = json.decode(responseCrew) as List;
      crew = crewJsonList.map((e) => Crew.fromJson(e)).toList();
    }

    if(cast.isNotEmpty && crew.isNotEmpty) {
      credits = {
        'cast': cast,
        'crew': crew,
      };
    }
    // print('RETURN MovieDataSourceLocal - getMovieCreditsData() - credits == null [${credits == null}]');
    return credits;
  }

  Future<List<Movie>?> getCollectionMoviesData(int collectionId) async {
    // print('MovieDataSourceLocal - getCollectionMoviesData()');
    List<Movie>? collectionMovies;
    var response = _shared.getCollectionMoviesData(collectionId);

    if (response != null) {
      List list = json.decode(response) as List;
      collectionMovies = list.map((e) => Movie.fromJson(e)).toList();
    }

    // print('RETURN MovieDataSourceLocal - getCollectionMoviesData() - credits == null [${credits == null}]');
    return collectionMovies;
  }

  Future<List<Movie>?> getPersonMoviesData(int personId) async {
    // print('MovieDataSourceLocal - getMovieCreditsData()');
    List<Movie>? personMoviesCast;
    // List<Crew> crew = [];
    // Map<String, dynamic>? credits;
    var responseCast = _shared.getPersonMoviesData(personId);
    // var responseCrew = _shared.getExtendedMovieCrewData(movieId);

    if (responseCast != null) {
      List castJsonList = json.decode(responseCast) as List;
      personMoviesCast = castJsonList.map((e) => Movie.fromJson(e)).toList();
    }
    // if (responseCrew != null) {
    //   List crewJsonList = json.decode(responseCrew) as List;
    //   crew = crewJsonList.map((e) => Crew.fromJson(e)).toList();
    // }

    // if(cast.isNotEmpty && crew.isNotEmpty) {
    //   credits = {
    //     'cast': cast,
    //     'crew': crew,
    //   };
    // }
    // print('RETURN MovieDataSourceLocal - getMovieCreditsData() - credits == null [${credits == null}]');
    return personMoviesCast;
  }

  Future<List<Movie>?> getTrendingMoviesData() async {
    // print('MovieDataSourceLocal - getTrendingMoviesData()');
    List<Movie>? result;
    var response = _shared.getTrendingMoviesData();

    if (response != null) {
      String trendingMoviesDateStr = _shared.getTrendingMoviesDataDate()!;
      DateTime trendingMoviesDate = trendingMoviesDateStr.fromTimeStamp;

      if(trendingMoviesDate.difference(DateTime.now()).inDays.abs() < 7) {
        List list = json.decode(response) as List;
        result = List.from(list.map((e) => Movie.fromJson(e)).toList());
      }
    }
    return result;
  }

  Future<List<Movie>?> getPopularMoviesData(int page) async {
    // print('MovieDataSourceLocal - getPopularMoviesData()');
    List<Movie>? result;
    var response = _shared.getPopularMoviesData();

    if (response != null) {
      String popularMoviesDateStr = _shared.getPopularMoviesDataDate()!;
      DateTime popularMoviesDate = popularMoviesDateStr.fromTimeStamp;

      if(popularMoviesDate.difference(DateTime.now()).inDays.abs() < 2) {
        List list = json.decode(response) as List;
        result = List.from(list.map((e) => Movie.fromJson(e)).toList());
      }
    }
    // print('MovieDataSourceLocal - getPopularMoviesData() - RETURN IS NULL ${result == null} ');
    return result;
  }

  Future<List<Movie>?> getUpcomingMoviesData(int page) async {
    // print('MovieDataSourceLocal - getUpcomingMoviesData()');
    List<Movie>? result;
    var response = _shared.getUpcomingMoviesData();
    // response = null;

    if (response != null) {
      // String upcomingMoviesDateStr = _shared.getUpcomingMoviesDataDate()!;
      // DateTime upcomingMoviesDate = upcomingMoviesDateStr.fromTimeStamp;
      // DateTime upcomingMoviesDate = upcomingMoviesDateStr.fromTimeStamp;

      String upcomingMoviesMinMaxDateStr = _shared.getUpcomingMoviesDataDate()!;
      List<String> upcomingMoviesMinMaxDateArr = upcomingMoviesMinMaxDateStr.split('|');
      String dateMinimumStr = upcomingMoviesMinMaxDateArr.first;
      // String dateMaximumStr = upcomingMoviesMinMaxDateArr.last;

      DateTime dateMinimum = dateFormat.parse(dateMinimumStr);
      // DateTime dateMaximum = dateFormat.parse(dateMaximumStr);

      if(dateMinimum.difference(DateTime.now()).inDays.abs() < 7) {
        List list = json.decode(response) as List;
        result = List.from(list.map((e) => Movie.fromJson(e)).toList());
      }
    }
    // print('MovieDataSourceLocal - getUpcomingMoviesData() - RETURN IS NULL ${result == null} ');
    return result;
  }

  Future<List<MovieGenre>?> getGenresData() async {
    // print('MovieDataSourceLocal - getGenresData()');
    List<MovieGenre>? result;
    var response = _shared.getGenresData();

    if (response != null) {
      List list = json.decode(response) as List;
      result = List.from(list.map((e) => MovieGenre.fromJson(e)).toList());
    }
    // print('MovieDataSourceLocal - getGenresData() - RETURN IS NULL ${result == null} ');
    return result;
  }


  Future<ImdbRating?> getImdbMovieRating(String imdbId) async {
    log('MovieDataSourceLocal - getImdbMovieRating()');
    ImdbRating? result;
    var response = _shared.getMovieImdbData(imdbId);

    if (response != null) {
      result = ImdbRating.fromJson(json.decode(response));
    }
    log('RETURN MovieDataSourceLocal - getImdbMovieRating() - response == null [${response == null}]');
    return result;
  }

  Future<File?> getWorkoutItemFileWithProgress(
          {required String imageUrl,
          required String fileLocalRouteStr,
          bool matchSizeWithOrigin = true,
          Function? fn,
          String? rangeInBytes,
          CancelToken? cancelToken}) async =>
      await getItemFile(
        imageUrl: imageUrl,
        fileLocalRouteStr: fileLocalRouteStr,
        matchSizeWithOrigin: matchSizeWithOrigin,
      );
}
