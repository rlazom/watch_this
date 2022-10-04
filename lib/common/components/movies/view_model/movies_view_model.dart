import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watch_this/models/movie.dart';
import '../../../../repository/movies/movie_repository.dart';
import '../../../../services/shared_preferences_service.dart';
import '../../../constants.dart';
import '../../../enums.dart';
import '../../../providers/loader_state.dart';

class MoviesViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  final MovieRepository movieRepository;
  final titleNotifier = ValueNotifier<String?>(null);
  final moviesNotifier = ValueNotifier<List<Movie>?>(null);
  Function? futureFn;
  Function? sortFn;
  int currentPage = 1;
  bool isFullList = false;
  bool isLastPage = false;

  final ValueNotifier<bool> centerMapOnUserPositionNotifier =
      ValueNotifier<bool>(true);
  bool mapReady = false;

  MoviesViewModel()
      : movieRepository = MovieRepository(),
        sharedPreferencesService = SharedPreferencesService();

  @override
  void loadData({BuildContext? context, forceReload = false}) async {
    print('MoviesViewModel - loadData() - context == null [${context == null}], moviesNotifier.value == null [${moviesNotifier.value == null}]');

    if (success) {
      markAsLoading();
    }
    List<Future> futureList = [];

    if (context != null && moviesNotifier.value == null) {
      Map argMap = ModalRoute.of(context)!.settings.arguments as Map;

      titleNotifier.value = argMap['title'];
      futureFn = argMap['futureFn'];
      sortFn = argMap['sortFn'];
      isFullList = argMap['isFullList'] ?? false;
      print('MoviesViewModel - fn == null [${futureFn == null}]');

      if (futureFn == null) {
        List tList = argMap['list'] == null ? [] : argMap['list'] as List;
        moviesNotifier.value = List<Movie>.from(tList);

        // futureList.add(_getMoviesData(forceReload: forceReload));
      } else {
        futureList.add(futureFn!().then((value) {
          print('futureFn.THEN');
          if(sortFn != null) {
            value.sort(sortFn);
          }
          moviesNotifier.value = List<Movie>.from(value);
          _updateMoviesMediaFiles();
          // _getMoviesData(forceReload: forceReload);
        }));
      }
    }
    // userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    try {
      await Future.wait(futureList);
    } catch (e) {
      if (kDebugMode) {
        print(
            'MoviesViewModel - loadData(forceReload: "$forceReload") - CATCH e: "$e"');
      }
      markAsFailed(error: Exception(e));
      return;
    }
    markAsSuccess();
  }

  Future _getMoviesData({bool forceReload = false}) async {
    print('MoviesViewModel - _getMoviesData()');
    int moviesLength = moviesNotifier.value?.length ?? 0;
    int idxStart = (currentPage - 1) * 20;
    int idxEnd = currentPage * 20 - 1;
    idxEnd = (isFullList || idxEnd > moviesLength) ? moviesLength : idxEnd;
    print('..currentPage: "$currentPage" - [$idxStart|$idxEnd] - isFullList: "$isFullList"');

    List<Movie>? movies = List<Movie>.from(moviesNotifier.value?.sublist(idxStart, idxEnd) ?? []);

    print('..movies.isNotEmpty [${movies.isNotEmpty}]');
    if (movies.isNotEmpty) {
      // List<Movie> tMovies = [];
      // try {
      //   tMovies = await movieRepository.getMyMoviesData(
      //     myMoviesToWatch: movies.map((e) => e.id).toList(),
      //     source: forceReload ? SourceType.REMOTE : null,
      //   );
      // } catch (e){
      //   if(kDebugMode) {
      //     print('MoviesViewModel - _getMoviesData() - CATCH ERROR: "$e"');
      //   }
      // }

      // for (Movie mov in tMovies) {
      //   int movIdx = moviesNotifier.value?.indexOf(mov) ?? -1;
      //   print('MoviesViewModel - _getMoviesData() - mov: ${mov.id} - ${mov.title}, movIdx: "$movIdx"');
      //   if(movIdx != -1) {
      //     moviesNotifier.value!.elementAt(movIdx).updateMovieTileData(
      //       pWatchProvidersList: mov.watchProvidersList,
      //       pPosterPath: mov.posterPath,
      //     );
      //   }
      // }
      // print('MoviesViewModel - getMyMoviesData().THEN');

      _updateMoviesMediaFiles();
    }
  }

  getMoreData() async {
    currentPage++;
    List<Movie> tMovies = await futureFn!(
    // List<Movie> tMovies = await movieRepository.getPopularMoviesData(
      // myMoviesToWatch: moviesNotifier.value!.map((e) => e.id).toList(),
      page: currentPage,
      source: SourceType.REMOTE,
    );

    if(tMovies.isEmpty) {
      isLastPage = true;
    } else {
      List<Movie> currentMovies = List.from(moviesNotifier.value ?? []);
      currentMovies.addAll(tMovies);
      moviesNotifier.value = List.from(currentMovies);

      // _getMoviesData();
      _updateMoviesMediaFiles();
    }
  }

  _updateMoviesMediaFiles() {
    for (Movie movie in moviesNotifier.value!) {
      if (movie.posterPath != null && movie.posterPath!.trim() != '') {
        String imageUrl = R.urls.image(movie.posterPath!);
        movie.fPoster = movieRepository.getItemFile(
            fileUrl: imageUrl, matchSizeWithOrigin: false);
      }
    }
  }
}
