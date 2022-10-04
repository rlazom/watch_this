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

  final trendingListNotifier = ValueNotifier<List<Movie>?>(null);
  final popularListNotifier = ValueNotifier<List<Movie>?>(null);
  final myMoviesListNotifier = ValueNotifier<List<Movie>?>(null);
  final upcomingMoviesListNotifier = ValueNotifier<List<Movie>?>(null);

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
      getMyMovieDataList(forceReload: forceReload),
      _getUpcomingMovieDataList(forceReload: forceReload),
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
    updateMediaFiles();
  }

  updateMediaFiles({bool trending = true, bool popular = true, bool myMovies = true, bool upcoming = true}) {
    if (trending) {
      _updateMovieImages(trendingListNotifier.value);
    }

    if (popular) {
      _updateMovieImages(popularListNotifier.value);
    }

    if (myMovies) {
      _updateMovieImages(myMoviesListNotifier.value);
    }

    if (upcoming) {
      _updateMovieImages(upcomingMoviesListNotifier.value);
    }
  }

  _updateMovieImages(List? list) {
    for (Movie movie in list ?? []) {
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

    // trendingListNotifier.value = List.from(tList.take(10));
    tList = List.from(tList.take(10));
    List<Movie> tList2 = await movieRepository.getMyMoviesData(
      myMoviesToWatch: tList.map((e) => e.id).toList(),
      source: forceReload ? SourceType.REMOTE : null,
    );
    trendingListNotifier.value = List.from(tList2);
  }

  Future _getPopularMovieDataList({bool forceReload = false}) async {
    // print('_getPopularMovieDataList()');
    List<Movie> tList = await movieRepository.getPopularMoviesData(
        source: forceReload ? SourceType.REMOTE : null);

    tList = List.from(tList.take(10));
    List<Movie> tList2 = await movieRepository.getMyMoviesData(
      myMoviesToWatch: tList.map((e) => e.id).toList(),
      source: forceReload ? SourceType.REMOTE : null,
    );

    // print('_getPopularMovieDataList() - RETURN - ${tList.length}');
    // popularListNotifier.value = List.from(tList);
    popularListNotifier.value = List.from(tList2);
  }

  Future getMyMovieDataList({bool forceReload = false, List<int>? movieIdList}) async {
    List<Movie> tList = await movieRepository.getMyMoviesData(
      myMoviesToWatch: movieIdList ?? userProvider.toWatch,
      source: forceReload ? SourceType.REMOTE : null,
    );

    myMoviesListNotifier.value = List.from(tList);
  }

  Future _getUpcomingMovieDataList({bool forceReload = false}) async {
    List<Movie> tList = await movieRepository.getUpcomingMoviesData(
      source: forceReload ? SourceType.REMOTE : null,
    );
    List<Movie> tList2 = await movieRepository.getMyMoviesData(
      myMoviesToWatch: tList.map((e) => e.id).toList(),
      source: forceReload ? SourceType.REMOTE : null,
    );

    upcomingMoviesListNotifier.value = List.from(tList2);
  }

  navigateToDetails(Movie movie) {
    navigator.toRoute(routeMovieDetails, arguments: movie);
  }

  navigateToPopularViewAll() {
    String popularMoviesStr = translate('POPULAR_MOVIES_TEXT');
    Map argMap = {
      'title': popularMoviesStr,
      'futureFn': movieRepository.getPopularMoviesData,
    };
    navigator.toRoute(routeMoviesPage, arguments: argMap);
  }

  navigateToUpcomingViewAll() {
    String titleStr = translate('UPCOMING_MOVIES_TEXT');
    Map argMap = {
      'title': titleStr,
      'futureFn': movieRepository.getUpcomingMoviesData,
    };
    navigator.toRoute(routeMoviesPage, arguments: argMap);
  }
}
