import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/routes.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/person.dart';

import '../../../../repository/movies/movie_repository.dart';
import '../../../../services/shared_preferences_service.dart';
import '../../../constants.dart';
import '../../../enums.dart';
import '../../../providers/loader_state.dart';
import '../../../providers/user_provider.dart';

class PersonDetailsViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  final MovieRepository movieRepository;
  late UserProvider userProvider;
  Person? person;
  final personMoviesNotifier = ValueNotifier<List<Movie>>([]);

  final ValueNotifier<bool> centerMapOnUserPositionNotifier =
      ValueNotifier<bool>(true);
  bool mapReady = false;

  PersonDetailsViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  void loadData({BuildContext? context, forceReload = false}) async {
    if (success) {
      markAsLoading();
    }

    if (context != null && person == null) {
      person = ModalRoute.of(context)!.settings.arguments as Person;
    }
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> futureList = [
      _getPersonMovies(person!.id, forceReload: forceReload),
    ];

    try {
      await Future.wait(futureList);
    } catch (e) {
      print(
          'PersonDetailsViewModel - loadData(forceReload: "$forceReload") - CATCH e: "$e"');
      markAsFailed(error: Exception(e));
      return;
    }
    markAsSuccess();

    _updateMediaFiles();
  }

  Future _getPersonMovies(int personId, {bool forceReload = false}) async {
    // print('PersonDetailsViewModel - _getPersonMovies(personId: "$personId")');

    List<Movie> tPersonMovies = await movieRepository.getPersonMoviesData(
      personId: personId,
      source: forceReload ? SourceType.REMOTE : null,
    );

    // tPersonMovies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    // tPersonMovies.sort();
    // tPersonMovies = List.from(tPersonMovies.take(10));

    // print('RETURN PersonDetailsViewModel - _getPersonMovies(movieId: "$personId")');
    // person = tPerson;
    personMoviesNotifier.value = List.from(tPersonMovies);
    _updateMoviesMediaFiles();
  }

  _updateMediaFiles() {
    if (person?.profilePath != null && person!.profilePath!.trim() != '') {
      String imageUrl = R.urls.image(person!.profilePath!);
      person!.fProfile = movieRepository.getItemFile(
          fileUrl: imageUrl, matchSizeWithOrigin: false);
    }
  }
  _updateMoviesMediaFiles() {
    for(Movie movie in personMoviesNotifier.value) {
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
