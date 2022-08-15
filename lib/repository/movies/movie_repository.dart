import 'package:watch_this/repository/movies/data_sources/movie_data_source_local.dart';
import 'package:watch_this/repository/r_master/r_master_repository.dart';

import '../../common/enums.dart';
import '../../models/movie.dart';
import 'data_sources/movie_data_source_remote.dart';

class MovieRepository extends RMasterRepository {
  MovieRepository()
      : super(
          local: MovieDataSourceLocal(),
          remote: MovieDataSourceRemote(),
          extendedPath: 'movies',
        );

  Future<List<Movie>> getTrendingMoviesData({SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      // SourceType.LOCAL: local.getTrendingMoviesData,
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
