import 'package:watch_this/models/media.dart';
import 'package:watch_this/models/movie_genre.dart';
import 'package:watch_this/repository/movies/data_sources/movie_data_source_local.dart';
import 'package:watch_this/repository/r_master/r_master_repository.dart';

import '../../common/enums.dart';
import '../../models/movie.dart';
import 'data_sources/movie_data_source_remote.dart';

class MovieRepository extends RMasterRepository {
  MovieRepository({String? extendedPath})
      : super(
          local: MovieDataSourceLocal(),
          remote: MovieDataSourceRemote(),
          extendedPath: extendedPath ?? 'movies',
        );

  Future<Movie> getExtendedMovieData(
      {required int movieId, SourceType? source}) async {
    // print('MovieRepository - getExtendedMovieData(movieId: "$movieId", source: "$source")');

    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getExtendedMovieData,
      SourceType.REMOTE: remote.getExtendedMovieData,
    };

    return await getAllItemsData(
        allSources: allSources,
        source: source,
        param: movieId,
        singleResult: true);
  }

  Future<Map> getMovieCreditsData(
      {required int movieId, SourceType? source}) async {
    // print('MovieRepository - getMovieCastData(movieId: "$movieId")');

    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getMovieCreditsData,
      SourceType.REMOTE: remote.getMovieCreditsData,
    };

    return await getAllItemsData(
        allSources: allSources,
        source: source,
        param: movieId,
        singleResult: true);
  }

  Future<List> getCollectionMoviesData(
      {required int collectionId, SourceType? source}) async {
    // print('MovieRepository - getMovieCollectionData(movieId: "$movieId")');

    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getCollectionMoviesData,
      SourceType.REMOTE: remote.getCollectionMoviesData,
    };

    return await getAllItemsData(
        allSources: allSources, source: source, param: collectionId);
  }

  Future<List<Movie>> getPersonMoviesData(
      {required int personId, SourceType? source}) async {
    // print('MovieRepository - getPersonMoviesData(personId: "personId")');

    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getPersonMoviesData,
      SourceType.REMOTE: remote.getPersonMoviesData,
    };

    return await getAllItemsData(
        allSources: allSources,
        source: source,
        param: personId,
        singleResult: true);
  }

  Future<List<Movie>> getMyMoviesData(
      {required List<int> myMoviesToWatch, SourceType? source}) async {
    List<Movie> result = [];

    List<Future> futureList = [];
    for (int movieId in myMoviesToWatch) {
      futureList.add(getExtendedMovieData(movieId: movieId, source: source)
          .then((value) => result.add(value)));
    }
    try {
      await Future.wait(futureList);
    } catch (e) {
      print('MovieRepository - getMyMoviesData() - CATCH e: "$e"');
      rethrow;
    }

    return List<Movie>.from(result);
  }

  Future<List<Movie>> getTrendingMoviesData({SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getTrendingMoviesData,
      SourceType.REMOTE: remote.getTrendingMoviesData,
    };

    List result = await getAllItemsData(allSources: allSources, source: source);
    return List<Movie>.from(result);
  }

  Future<List<Movie>> getPopularMoviesData({int page = 1, SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getPopularMoviesData,
      SourceType.REMOTE: remote.getPopularMoviesData,
    };

    List result = await getAllItemsData(allSources: allSources, source: source, param: page);
    return List<Movie>.from(result);
  }

  Future<List<Movie>> getUpcomingMoviesData({int page = 1, SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getUpcomingMoviesData,
      SourceType.REMOTE: remote.getUpcomingMoviesData,
    };

    List result = await getAllItemsData(allSources: allSources, source: source, param: page);
    return List<Movie>.from(result);
  }

  Future<List<MovieGenre>> getGenresData({SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getGenresData,
      SourceType.REMOTE: remote.getGenresData,
    };

    List result = await getAllItemsData(allSources: allSources, source: source);
    return List<MovieGenre>.from(result);
  }

  Future<List<Media>> getMultiSearchData({int page = 1, required String text, SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      // SourceType.LOCAL: local.getMultiSearchData,
      SourceType.REMOTE: remote.getMultiSearchData,
    };

    Map queryMap = {
      'text': text,
      'page': page,
    };

    List result = await getAllItemsData(allSources: allSources, source: source, param: queryMap);
    return List<Media>.from(result);
  }
}
