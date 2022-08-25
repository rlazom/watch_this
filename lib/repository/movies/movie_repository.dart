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
    // print('MovieRepository - getExtendedMovieData(movieId: "$movieId")');

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

  //TODO
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

    // List result = await getAllItemsData(allSources: allSources, source: source);
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

  Future<List<Movie>> getPopularMoviesData({SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      SourceType.LOCAL: local.getPopularMoviesData,
      SourceType.REMOTE: remote.getPopularMoviesData,
    };

    List result = await getAllItemsData(allSources: allSources, source: source);
    return List<Movie>.from(result);
  }
}
