import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/models/movie.dart';

import '../../../../repository/movies/movie_repository.dart';
import '../../../../services/shared_preferences_service.dart';
import '../../../constants.dart';
import '../../../enums.dart';
import '../../../providers/loader_state.dart';
import '../../../providers/user_provider.dart';

class MovieDetailsViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  final MovieRepository movieRepository;
  late UserProvider userProvider;
  Movie? movie;
  List<Movie> trendingList = [];
  List<Movie> popularList = [];

  final ValueNotifier<bool> centerMapOnUserPositionNotifier =
  ValueNotifier<bool>(true);
  bool mapReady = false;

  MovieDetailsViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  void loadData({BuildContext? context, forceReload = false}) async {
    if (success) {
      markAsLoading();
    }

    if (context != null && movie == null) {
      movie = ModalRoute.of(context)!.settings.arguments as Movie;
    }
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> futureList = [
      _getMovieExtendedData(movie!.id, forceReload: forceReload)
          .then((value) => movie = value),
    ];

    try {
      await Future.wait(futureList);
    } catch (e) {
      print(
          'MovieDetailsViewModel - loadData(forceReload: "$forceReload") - CATCH e: "$e"');
      markAsFailed(error: Exception(e));
      return;
    }
    markAsSuccess();

    _updateMediaFiles();
  }

  Future<Movie> _getMovieExtendedData(int movieId,
      {bool forceReload = false}) async {
    // print('MovieDetailsViewModel - _getMovieExtendedData(movieId: "$movieId")');

    Movie tMovie = await movieRepository.getExtendedMovieData(
        source: forceReload ? SourceType.REMOTE : null, movieId: movieId);

    // print('RETURN MovieDetailsViewModel - _getMovieExtendedData(movieId: "$movieId")');
    return tMovie;
  }

  _updateMediaFiles() {
    if (movie!.posterPath.trim() != '') {
      String imageUrl = R.urls.image(movie!.posterPath);
      movie!.fPoster =
          movieRepository.getItemFile(fileUrl: imageUrl, matchSizeWithOrigin: false);
    }
    if (movie!.backdropPath.trim() != '') {
      String imageUrl = R.urls.image(movie!.backdropPath);
      movie!.fBackdrop =
          movieRepository.getItemFile(fileUrl: imageUrl, matchSizeWithOrigin: false);
    }

    // for (Workout item in fullList) {
    //   if (item.level!.image != null && item.level!.image!.trim() != '') {
    //     item.level!.fImage =
    //         _workoutRepository.getWorkoutItemFile(fileUrl: item.level!.image!);
    //   }
    //
    //   for (Tool tool in item.tools ?? []) {
    //     String? toolImage = tool.image;
    //
    //     if (toolImage != null && toolImage.trim() != '') {
    //       tool.fImage = _workoutRepository.getWorkoutItemFile(
    //           fileUrl: toolImage, matchSizeWithOrigin: false);
    //     }
    //   }
    // }
  }
}
