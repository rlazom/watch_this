import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/models/cast.dart';
import 'package:watch_this/models/crew.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/person.dart';

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
  final movieCreditsNotifier = ValueNotifier<List<Person>>([]);
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
    _getCastData(movie!.id, forceReload: forceReload);
  }

  Future<Movie> _getMovieExtendedData(int movieId,
      {bool forceReload = false}) async {
    // print('MovieDetailsViewModel - _getMovieExtendedData(movieId: "$movieId")');

    Movie tMovie = await movieRepository.getExtendedMovieData(
      movieId: movieId,
      source: forceReload ? SourceType.REMOTE : null,
    );

    // print('RETURN MovieDetailsViewModel - _getMovieExtendedData(movieId: "$movieId")');
    return tMovie;
  }

  _updateMediaFiles() {
    if (movie!.posterPath.trim() != '') {
      String imageUrl = R.urls.image(movie!.posterPath);
      movie!.fPoster = movieRepository.getItemFile(
          fileUrl: imageUrl, matchSizeWithOrigin: false);
    }
    if (movie!.backdropPath.trim() != '') {
      String imageUrl = R.urls.image(movie!.backdropPath);
      movie!.fBackdrop = movieRepository.getItemFile(
          fileUrl: imageUrl, matchSizeWithOrigin: false);
    }
  }

  // TODO
  _getImdbData() {}

  _getCastData(int movieId, {bool forceReload = false}) async {
    Map movieCredits = await movieRepository.getMovieCreditsData(
      movieId: movieId,
      source: forceReload ? SourceType.REMOTE : null,
    );

    List<Cast> movieCastList = [];
    List<Crew> movieCrewList = [];

    if(movieCredits['cast'] != null) {
      movieCastList = List.from(movieCredits['cast']);
    }
    if(movieCredits['crew'] != null) {
      movieCrewList = List.from(movieCredits['crew']);
    }
    List<Person> movieCreditsList = [];

    const List<String> crewJobs = ['Director', 'Co-Director', 'Producer'];
    movieCastList.removeWhere((element) => element.order > 9);
    movieCrewList.retainWhere((element) => crewJobs.contains(element.job));
    movieCreditsList.addAll(movieCastList);
    movieCreditsList.addAll(movieCrewList);

    for(Person person in movieCreditsList) {
      if (person.profilePath != null && person.profilePath!.trim() != '') {
        String imageUrl = R.urls.image(person.profilePath!);
        person.fProfile = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
    }
    movieCreditsNotifier.value = List.from(movieCreditsList);
  }
}
