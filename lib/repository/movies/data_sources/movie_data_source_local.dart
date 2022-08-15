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

  Future<List<Movie>?> getTrendingMoviesData() async {
    print('aki_0');
    List<Movie>? result;
    var response = _shared.getTrendingMoviesData();
    print('aki_1');

    if (response != null) {
      print('aki_2');
      String trendingMoviesDateStr = _shared.getTrendingMoviesDataDate()!;
      DateTime trendingMoviesDate = trendingMoviesDateStr.fromTimeStamp;
      print('aki_3');

      if(trendingMoviesDate.difference(DateTime.now()).inDays.abs() < 7) {

        print('aki_4');

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
