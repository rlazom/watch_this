import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:watch_this/common/extensions.dart';
import 'package:watch_this/models/movie.dart';

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

  Future<List<Movie>?> getPopularMoviesData() async {
    List<Movie>? result;
    var response = _shared.getPopularMoviesData();

    if (response != null) {
      String popularMoviesDateStr = _shared.getPopularMoviesDataDate()!;
      DateTime popularMoviesDate = popularMoviesDateStr.fromTimeStamp;

      if(popularMoviesDate.difference(DateTime.now()).inDays.abs() < 7) {
        List list = json.decode(response) as List;
        result = List.from(list.map((e) => Movie.fromJson(e)).toList());
      }
    }
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
