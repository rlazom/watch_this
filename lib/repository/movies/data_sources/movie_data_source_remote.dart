import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:watch_this/models/cast.dart';
import 'package:watch_this/models/crew.dart';

import '../../../common/constants.dart';
import '../../../models/movie.dart';
import '../../r_master/data_sources/r_master_data_source_remote.dart';

class MovieDataSourceRemote extends RMasterDataSourceRemote {
  MovieDataSourceRemote() : super();

  Future<Movie> getExtendedMovieData(int movieId) async {
    // print('MovieDataSourceRemote - getExtendedMovieData()');
    String url = R.urls.movieModule.details(movieId: movieId);

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url);
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getExtendedMovieData() - ["$error"');
      rethrow;
    }

    Movie movie = Movie.fromJson(data);
    shared.setExtendedMovieData(json.encode(movie), movieId);

    // print('RETURN MovieDataSourceRemote - getExtendedMovieData()');
    return movie;
  }

  Future<Map> getMovieCreditsData(int movieId) async {
    // print('MovieDataSourceRemote - getMovieCreditsData()');
    String url = R.urls.movieModule.credits(movieId: movieId);

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url);
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getMovieCreditsData() - ["$error"');
      rethrow;
    }

    List castJsonList = data['cast'] as List;
    List crewJsonList = data['crew'] as List;
    List<Cast> cast = castJsonList.map((e) => Cast.fromJson(e)).toList();
    List<Crew> crew = crewJsonList.map((e) => Crew.fromJson(e)).toList();
    shared.setExtendedMovieCastData(json.encode(cast), movieId);
    shared.setExtendedMovieCrewData(json.encode(crew), movieId);

    Map<String, dynamic> credits = {
      'cast': cast,
      'crew': crew,
    };

    // print('RETURN MovieDataSourceRemote - getExtendedMovieData()');
    return credits;
  }

  Future<List<Movie>> getTrendingMoviesData() async {
    // print('MovieDataSourceRemote - getTrendingMoviesData()');
    String url = R.urls.trending;

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url);
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getTrendingMoviesData() - ["$error"');
      rethrow;
    }

    List list = data['results'] as List;
    List<Movie> movieList = list.map((e) => Movie.fromJson(e)).toList();
    shared.setTrendingMoviesData(json.encode(movieList));

    return movieList;
  }

  Future<List<Movie>> getPopularMoviesData() async {
    String url = R.urls.popularity;

    dynamic data;
    try {
      data = await fetchData(url: url);
    } catch (error) {
      print('MovieDataSourceRemote.getPopularMoviesData() - ["$error"');
      rethrow;
    }

    List list = data['results'] as List;
    List<Movie> movieList = list.map((e) => Movie.fromJson(e)).toList();
    shared.setPopularMoviesData(json.encode(movieList));

    return movieList;
  }

  /// rangeInBytes='0-100'
  Future<File?> getWorkoutItemFileWithProgress(
      {required String imageUrl,
      required String fileLocalRouteStr,
      bool matchSizeWithOrigin = true,
      Function(int, int)? fn,
      String? rangeInBytes,
      CancelToken? cancelToken}) async {
    File localFile = File(fileLocalRouteStr);

    Options? options;
    if (rangeInBytes != null) {
      // Options options = Options(headers: {'Range': 'bytes=0-0'});
      options = Options(headers: {'Range': 'bytes=$rangeInBytes'});
    }
    var dio = new Dio();
    try {
      await dio.download(imageUrl, fileLocalRouteStr,
          options: options, onReceiveProgress: fn, cancelToken: cancelToken);
    } catch (e) {
      return null;
    }
    return localFile;
  }
}
