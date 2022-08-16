import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/models/movie.dart';
import '../../../common/enums.dart';
import '../../../common/providers/loader_state.dart';
import '../../../common/providers/user_provider.dart';
import '../../../repository/movies/movie_repository.dart';
import '../../../services/shared_preferences_service.dart';

class HomeViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  final MovieRepository movieRepository;
  late UserProvider userProvider;
  List<Movie> trendingList = [];
  List<Movie> popularList = [];

  final ValueNotifier<bool> centerMapOnUserPositionNotifier =
      ValueNotifier<bool>(true);
  bool mapReady = false;

  HomeViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  void loadData({BuildContext? context, forceReload = false}) async {
    if (success) {
      markAsLoading();
    }
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> futureList = [
      _getTrendingMovieDataList(forceReload: forceReload)
          .then((value) => trendingList = List.from(value)),
      // _getPopularMovieDataList(forceReload: forceReload)
      //     .then((value) => popularList = List.from(value)),
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
  }

  Future<List<Movie>> _getTrendingMovieDataList(
      {bool forceReload = false}) async {
    List<Movie> tList = await movieRepository.getTrendingMoviesData(
        source: forceReload ? SourceType.REMOTE : null);

    return tList;
  }

  Future<List<Movie>> _getPopularMovieDataList(
      {bool forceReload = false}) async {
    List<Movie> tList = await movieRepository.getPopularMoviesData(
        source: forceReload ? SourceType.REMOTE : null);

    return tList;
  }
}
