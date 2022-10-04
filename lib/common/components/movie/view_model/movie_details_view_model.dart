import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/routes.dart';
import 'package:watch_this/common/widgets/flat_image.dart';
import 'package:watch_this/models/cast.dart';
import 'package:watch_this/models/company.dart';
import 'package:watch_this/models/crew.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/person.dart';
import 'package:watch_this/models/watch_provider.dart';

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
  final movieCreditsNotifier = ValueNotifier<List<Person>?>(null);
  final collectionMoviesNotifier = ValueNotifier<List<Movie>?>(null);

  MovieDetailsViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  Future loadData({BuildContext? context, forceReload = false}) async {
    // print('MovieDetailsViewModel - loadData(forceReload = "$forceReload")');
    if (success) {
      markAsLoading();
    }

    // print('..loadData() - context != null => "${context != null}", movie == null => "${movie == null}"');
    if (context != null && movie == null) {
      movie = ModalRoute.of(context)!.settings.arguments as Movie;
    }
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> futureList = [
      _getMovieExtendedData(movie!.id, forceReload: forceReload),
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

    if (movie!.belongsToCollection != null) {
      _getCollectionMoviesData(movie!.belongsToCollection!['id'],
          forceReload: forceReload);
    } else {
      collectionMoviesNotifier.value = [];
    }
  }

  Future _getMovieExtendedData(int movieId, {bool forceReload = false}) async {
    // print('MovieDetailsViewModel - _getMovieExtendedData(movieId: "$movieId", forceReload: "$forceReload")');

    Movie tMovie = await movieRepository.getExtendedMovieData(
      movieId: movieId,
      source: forceReload ? SourceType.REMOTE : null,
    );

    tMovie.similarMovies?.removeWhere((element) => element == movie);
    movie = tMovie;
    // print('RETURN MovieDetailsViewModel - _getMovieExtendedData(movieId: "$movieId")');
  }

  _updateMediaFiles() {
    if (movie!.posterPath != null && movie!.posterPath!.trim() != '') {
      String imageUrl = R.urls.image(movie!.posterPath!);
      movie!.fPoster = movieRepository.getItemFile(
          fileUrl: imageUrl, matchSizeWithOrigin: false);
    }
    if (movie!.backdropPath != null && movie!.backdropPath!.trim() != '') {
      String imageUrl = R.urls.image(movie!.backdropPath!);
      movie!.fBackdrop = movieRepository.getItemFile(
          fileUrl: imageUrl, matchSizeWithOrigin: false);
    }

    if (movie!.productionCompanies != null &&
        movie!.productionCompanies!.isNotEmpty) {
      movie!.productionCompanies!.removeWhere((company) =>
          company.logoPath == null || company.logoPath!.trim() == '');
      for (Company company in movie!.productionCompanies!) {
        // if (company.logoPath != null && company.logoPath!.trim() != '') {
        String imageUrl = R.urls.image(company.logoPath!);
        company.fLogo = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
        // }
      }
    }

    if (movie!.watchProvidersList != null &&
        movie!.watchProvidersList!.isNotEmpty) {
      // movie!.watchProvidersList!.removeWhere((element) => element.displayPriority > 20);
      movie!.watchProvidersList!.sort();
      for (WatchProvider provider in movie!.watchProvidersList!) {
        if (provider.logoPath != null && provider.logoPath!.trim() != '') {
          String imageUrl = R.urls.image(provider.logoPath!);
          provider.fLogo = movieRepository.getItemFile(
              fileUrl: imageUrl, matchSizeWithOrigin: false);
        }
      }
    }

    if (movie!.similarMovies != null && movie!.similarMovies!.isNotEmpty) {
      for (Movie cMovie in movie!.similarMovies!) {
        if (cMovie.posterPath != null && cMovie.posterPath!.trim() != '') {
          String imageUrl = R.urls.image(cMovie.posterPath!);
          cMovie.fPoster = movieRepository.getItemFile(
              fileUrl: imageUrl, matchSizeWithOrigin: false);
        }
      }
    }
  }

  // TODO
  _getImdbData() {}

  _getCollectionMoviesData(int collectionId, {bool forceReload = false}) async {
    // print('MovieDetailsViewModel - _getCollectionMoviesData(collectionId: "collectionId")');

    List tCollectionMovies = await movieRepository.getCollectionMoviesData(
      collectionId: collectionId,
      source: forceReload ? SourceType.REMOTE : null,
    );

    tCollectionMovies.removeWhere((element) => element == movie);
    for (Movie cMovie in tCollectionMovies) {
      if (cMovie.posterPath != null && cMovie.posterPath!.trim() != '') {
        String imageUrl = R.urls.image(cMovie.posterPath!);
        cMovie.fPoster = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
      if (cMovie.backdropPath != null && cMovie.backdropPath!.trim() != '') {
        String imageUrl = R.urls.image(cMovie.backdropPath!);
        cMovie.fBackdrop = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
    }

    // print('RETURN MovieDetailsViewModel - _getCollectionMoviesData(collectionId: "$collectionId", length: "${tCollectionMovies.length}")');
    tCollectionMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    // tCollectionMovies.sort((Movie a, Movie b) => (a.releaseDate ?? DateTime(1900)).compareTo(b.releaseDate ?? DateTime(1900)));
    collectionMoviesNotifier.value = List.from(tCollectionMovies);
    // _updateMoviesMediaFiles();
  }

  _getCastData(int movieId, {bool forceReload = false}) async {
    Map movieCredits = await movieRepository.getMovieCreditsData(
      movieId: movieId,
      source: forceReload ? SourceType.REMOTE : null,
    );

    List<Cast> movieCastList = [];
    List<Crew> movieCrewList = [];

    if (movieCredits['cast'] != null) {
      movieCastList = List.from(movieCredits['cast']);
    }
    if (movieCredits['crew'] != null) {
      movieCrewList = List.from(movieCredits['crew']);
    }
    List<Person> movieCreditsList = [];

    const List<String> crewJobs = ['Director', 'Co-Director', 'Producer'];
    movieCastList.removeWhere((element) => (element.order ?? 99) > 9);
    movieCrewList.retainWhere((element) => crewJobs.contains(element.job));
    movieCreditsList.addAll(movieCastList);

    for (Person person in movieCrewList) {
      if (!movieCreditsList.contains(person)) {
        movieCreditsList.add(person);
      } else {
        Person tPerson =
            movieCreditsList.firstWhere((element) => element == person);
        tPerson.job = person.job;
      }
    }

    for (Person person in movieCreditsList) {
      if (person.profilePath != null && person.profilePath!.trim() != '') {
        String imageUrl = R.urls.image(person.profilePath!);
        person.fProfile = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
    }
    movieCreditsNotifier.value = List.from(movieCreditsList);
  }

  navigateToPersonDetails(Person person) {
    String titleStr = person.name;
    Map argMap = {
      'title': titleStr,
      'futureFn': () => movieRepository.getPersonMoviesData(personId: person.id),
      'sortFn': (Movie a, Movie b) => (b.releaseDate ?? DateTime(1900)).compareTo(a.releaseDate ?? DateTime(1900)),
      'isFullList': true,
    };
    navigator.toRoute(routeMoviesPage, arguments: argMap);
  }

  expandImage(String? image) {
    if (image == null) {
      return;
    }

    String imageUrl = R.urls.imageOriginal(movie!.posterPath!);
    String tag = image.split('/').last.split('.').first;

    Navigator.push(
      navigator.context,
      MaterialPageRoute(
        builder: (context) => FlatImage(
          tag: tag,
          imageRoute: image,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
