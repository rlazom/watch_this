import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/models/movie.dart';
import '../../../common/enums.dart';
import '../../../common/providers/loader_state.dart';
import '../../../common/providers/user_provider.dart';
import '../../../common/routes.dart';
import '../../../repository/movies/movie_repository.dart';
import '../../../services/shared_preferences_service.dart';

class HomeViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  final MovieRepository movieRepository;
  late UserProvider userProvider;
  // List<Movie> trendingList = [];
  // List<Movie> popularList = [];
  final trendingListNotifier = ValueNotifier<List<Movie>?>(null);
  final popularListNotifier = ValueNotifier<List<Movie>?>(null);
  final myMoviesListNotifier = ValueNotifier<List<Movie>?>(null);

  final ValueNotifier<bool> centerMapOnUserPositionNotifier =
      ValueNotifier<bool>(true);
  bool mapReady = false;

  HomeViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  Future loadData({BuildContext? context, forceReload = false}) async {
    if (success) {
      markAsLoading();
    }
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> futureList = [
      _getTrendingMovieDataList(forceReload: forceReload),
      _getPopularMovieDataList(forceReload: forceReload),
      _getMyMovieDataList(forceReload: forceReload),
    ];

    try {
      await Future.wait(futureList);
    } catch (e) {
      print(
          'HomeViewModel - loadData(forceReload: "$forceReload") - CATCH e: "$e"');
      markAsFailed(error: Exception(e));
      return;
    }
    markAsSuccess();
    _updateMediaFiles();
  }

  Future _getMyMovieDataList({bool forceReload = false}) async {
    // List<Movie> tList = await movieRepository.getMyMoviesData(
    //     source: forceReload ? SourceType.REMOTE : null);
    //
    // myMoviesListNotifier.value = List.from(tList);
  }

  _updateMediaFiles() {
    for(Movie movie in trendingListNotifier.value ?? []) {
      if (movie.posterPath != null && movie.posterPath!.trim() != '') {
        String imageUrl = R.urls.image(movie.posterPath!);
        movie.fPoster = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
      if (movie.backdropPath != null && movie.backdropPath!.trim() != '') {
        String imageUrl = R.urls.imageW500(movie.backdropPath!);
        movie.fBackdrop = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
    }

    for(Movie movie in popularListNotifier.value ?? []) {
      if (movie.posterPath != null && movie.posterPath!.trim() != '') {
        String imageUrl = R.urls.image(movie.posterPath!);
        movie.fPoster = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
      if (movie.backdropPath != null && movie.backdropPath!.trim() != '') {
        String imageUrl = R.urls.imageW500(movie.backdropPath!);
        movie.fBackdrop = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
    }
  }

  Future _getTrendingMovieDataList({bool forceReload = false}) async {
    List<Movie> tList = await movieRepository.getTrendingMoviesData(
        source: forceReload ? SourceType.REMOTE : null);

    trendingListNotifier.value = List.from(tList);
  }

  Future _getPopularMovieDataList(
      {bool forceReload = false}) async {
    // print('_getPopularMovieDataList()');
    List<Movie> tList = await movieRepository.getPopularMoviesData(
        source: forceReload ? SourceType.REMOTE : null);

    // print('_getPopularMovieDataList() - RETURN - ${tList.length}');
    popularListNotifier.value = List.from(tList);
  }

  navigateToDetails(Movie movie) {
    navigator.toRoute(routeMovieDetails, arguments: movie);
  }
}
