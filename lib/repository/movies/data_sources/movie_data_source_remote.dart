import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../../common/constants.dart';
import '../../../models/movie.dart';
import '../../r_master/data_sources/r_master_data_source_remote.dart';

class MovieDataSourceRemote extends RMasterDataSourceRemote {
  MovieDataSourceRemote() : super();

  Future<List<Movie>> getTrendingMoviesData() async {
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
