import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/routes.dart';
import 'package:watch_this/models/movie.dart';
import '../../../../repository/movies/movie_repository.dart';
import '../../../../services/shared_preferences_service.dart';
import '../../../constants.dart';
import '../../../enums.dart';
import '../../../providers/loader_state.dart';
import '../../../providers/user_provider.dart';

class MoviesViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  final MovieRepository movieRepository;
  late UserProvider userProvider;
  final moviesNotifier = ValueNotifier<List<Movie>?>(null);

  final ValueNotifier<bool> centerMapOnUserPositionNotifier =
      ValueNotifier<bool>(true);
  bool mapReady = false;

  MoviesViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  void loadData({BuildContext? context, forceReload = false}) async {
    if (success) {
      markAsLoading();
    }

    if (context != null && moviesNotifier.value == null) {
      List tList = ModalRoute.of(context)!.settings.arguments as List;
      moviesNotifier.value = List<Movie>.from(tList);
    }
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> futureList = [
      _getMoviesData(forceReload: forceReload),
    ];

    try {
      await Future.wait(futureList);
    } catch (e) {
      if(kDebugMode) {
        print('MoviesViewModel - loadData(forceReload: "$forceReload") - CATCH e: "$e"');
      }
      markAsFailed(error: Exception(e));
      return;
    }
    markAsSuccess();
  }

  Future _getMoviesData({bool forceReload = false}) async {
    print('MoviesViewModel - _getMoviesData()');

    List<Movie>? movies = moviesNotifier.value;
    if(movies != null && movies.isNotEmpty) {
      List<Movie> tMovies = await movieRepository.getMyMoviesData(
        myMoviesToWatch: moviesNotifier.value!.map((e) => e.id).toList(),
        source: forceReload ? SourceType.REMOTE : null,
      );

      // tMovies.sort((a,b) => (b.releaseDate ?? DateTime(1900)).compareTo(a.releaseDate ?? DateTime(1900)));
      moviesNotifier.value = List.from(tMovies);
      _updateMoviesMediaFiles();
    }
  }

  _updateMoviesMediaFiles() {
    for(Movie movie in moviesNotifier.value!) {
      if (movie.posterPath != null && movie.posterPath!.trim() != '') {
        String imageUrl = R.urls.image(movie.posterPath!);
        movie.fPoster = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
    }
  }

  navigateToMovieDetails(Movie movie) {
    navigator.toRoute(routeMovieDetails, arguments: movie);
  }
}
