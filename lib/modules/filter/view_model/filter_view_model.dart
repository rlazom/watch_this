import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/common/routes.dart';
import 'package:watch_this/models/media.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/person.dart';
import '../../../common/enums.dart';
import '../../../common/providers/loader_state.dart';
import '../../../common/providers/user_provider.dart';
import '../../../repository/movies/movie_repository.dart';
import '../../../services/shared_preferences_service.dart';

class FilterViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  final MovieRepository movieRepository;
  late UserProvider userProvider;

  int currentPage = 1;
  bool isFullList = false;
  bool isLastPage = false;

  // final myMoviesListNotifier = ValueNotifier<List<Movie>?>(null);
  final ValueNotifier<List<Media>?> searchListNotifier = ValueNotifier<List<Media>?>(null);
  // final searchListNotifier = ValueNotifier<List<dynamic>?>(null);

  TextEditingController textEditingController = TextEditingController();

  FilterViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  Future loadData({BuildContext? context, forceReload = false}) async {
    if (success) {
      markAsLoading();
    }
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> futureList = [
      _getPopularMovieDataList(forceReload: forceReload),
      // getMyMovieDataList(forceReload: forceReload),
    ];

    try {
      await Future.wait(futureList);
    } catch (e) {
      print(
          'FilterViewModel - loadData(forceReload: "$forceReload") - CATCH e: "$e"');
      markAsFailed(error: Exception(e));
      return;
    }
    markAsSuccess();
    updateMediaFiles();
  }

  updateMediaFiles() {
    _updateMovieImages(searchListNotifier.value);
  }

  _updateMovieImages(List? list) {
    for (Media media in list ?? []) {
      if(media is Movie) {
        Movie movie = media;
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
      if(media is Person) {
        Person person = media;
        String? profilePath = person.profilePath;
        if(profilePath != null && profilePath.trim().isNotEmpty) {
          String imageUrl = R.urls.image(profilePath);
          person.fProfile = movieRepository.getItemFile(
              fileUrl: imageUrl, matchSizeWithOrigin: false);
        }
      }
    }
  }

  Future _getPopularMovieDataList({bool forceReload = false}) async {
    // print('_getPopularMovieDataList()');
    List<Movie> tList = await movieRepository.getPopularMoviesData(
        source: forceReload ? SourceType.REMOTE : null);

    tList = List.from(tList.take(18));
    List<Movie> tList2 = await movieRepository.getMyMoviesData(
      myMoviesToWatch: tList.map((e) => e.id).toList(),
      source: forceReload ? SourceType.REMOTE : null,
    );

    // print('_getPopularMovieDataList() - RETURN - ${tList.length}');
    // popularListNotifier.value = List.from(tList);
    // searchListNotifier.value = List.from(tList2);

    if(searchListNotifier.value == null) {
      searchListNotifier.value = List<Media>.from(tList2);
    } else {
      searchListNotifier.value = List.from(searchListNotifier.value!)..addAll(tList2);
    }
  }

  // Future getMyMovieDataList({bool forceReload = false, List<int>? movieIdList}) async {
  //   List<Movie> tList = await movieRepository.getMyMoviesData(
  //     myMoviesToWatch: movieIdList ?? userProvider.toWatch,
  //     source: forceReload ? SourceType.REMOTE : null,
  //   );
  //
  //   // myMoviesListNotifier.value = List.from(tList);
  //   if(searchListNotifier.value == null) {
  //     searchListNotifier.value = List.from(tList);
  //   } else {
  //     searchListNotifier.value = List.from(searchListNotifier.value!)..addAll(tList);
  //   }
  // }

  void clearMultiSearch() {
    textEditingController.clear();
    searchListNotifier.value = null;
    FocusScope.of(navigator.context).requestFocus(FocusNode());

    _getPopularMovieDataList().then((_) => updateMediaFiles());
  }

  Future getMultiSearchData() async {
    String text = textEditingController.text;
    print('getMultiSearchData(text: "$text")...');
    markAsLoading();

    List tList = await movieRepository.getMultiSearchData(text: text);

    print('getMultiSearchData() - tList: ${tList.length}');
    searchListNotifier.value = List.from(tList);
    markAsSuccess();

    print('getMultiSearchData() - updateMediaFiles()...');
    updateMediaFiles();
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
}
