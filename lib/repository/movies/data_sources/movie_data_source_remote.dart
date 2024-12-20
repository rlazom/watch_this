import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:watch_this/common/enums.dart';
import 'package:watch_this/models/cast.dart';
import 'package:watch_this/models/crew.dart';
import 'package:watch_this/models/imdb_rating.dart';
import 'package:watch_this/models/media.dart';
import 'package:watch_this/models/movie_genre.dart';

import '../../../common/constants.dart';
import '../../../models/movie.dart';
import '../../r_master/data_sources/r_master_data_source_remote.dart';

final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

class MovieDataSourceRemote extends RMasterDataSourceRemote {
  MovieDataSourceRemote() : super();

  Future<Movie> getExtendedMovieData(int movieId) async {
    // print('MovieDataSourceRemote - getExtendedMovieData()');
    String url = R.urls.movieModule.details(movieId: movieId);

    Map queryMap = {
      'append_to_response': 'watch/providers,release_dates,similar'
    };

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url, query: queryMap);
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getExtendedMovieData() - ["$error"');
      rethrow;
    }

    Movie movie = Movie.fromJson(data);
    shared.setExtendedMovieData(json.encode(movie), movieId);

    // print('RETURN MovieDataSourceRemote - getExtendedMovieData()');
    return movie;
  }

  Future<Map> getMovieCreditsData(int movieId) async {
    // print('MovieDataSourceRemote - getMovieCreditsData()');
    String url = R.urls.movieModule.credits(movieId: movieId);

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url, timeout: const Duration(seconds: 30));
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getMovieCreditsData() - ["$error"');
      rethrow;
    }

    List castJsonList = data['cast'] as List;
    List crewJsonList = data['crew'] as List;
    List<Cast> cast = castJsonList.map((e) => Cast.fromJson(e)).toList();
    List<Crew> crew = crewJsonList.map((e) => Crew.fromJson(e)).toList();
    shared.setExtendedMovieCastData(json.encode(cast), movieId);
    shared.setExtendedMovieCrewData(json.encode(crew), movieId);

    Map<String, dynamic> credits = {
      'cast': cast,
      'crew': crew,
    };

    // print('RETURN MovieDataSourceRemote - getExtendedMovieData()');
    return credits;
  }

  Future<List<Movie>> getCollectionMoviesData(int collectionId) async {
    // print('MovieDataSourceRemote - getCollectionMoviesData()');
    String url = R.urls.collection(collectionId);

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url);
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getCollectionMoviesData() - ["$error"');
      rethrow;
    }

    List list = data['parts'] as List;
    List<Movie> collectionMovies = list.map((e) => Movie.fromJson(e)).toList();
    shared.setCollectionMoviesData(json.encode(collectionMovies), collectionId);

    // print('RETURN MovieDataSourceRemote - getCollectionMoviesData() - ${collectionMovies.length}');
    return collectionMovies;
  }

  Future<List<Movie>> getPersonMoviesData(int personId) async {
    // print('MovieDataSourceRemote - getPersonMoviesData()');
    String url = R.urls.personModule.movies(personId: personId);

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url);
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getPersonMoviesData() - ["$error"');
      rethrow;
    }

    List castJsonList = data['cast'] as List;
    List crewJsonList = data['crew'] as List;
    List<Movie> personMovies = [];
    List<Movie> personMoviesCast = castJsonList.map((e) => Movie.fromJson(e)).toList();
    List<Movie> personMoviesCrew = crewJsonList.map((e) => Movie.fromJson(e)).toList();

    personMovies.addAll(personMoviesCast);
    for(Movie movie in personMoviesCrew) {
      if(!personMovies.contains(movie)) {
        personMovies.add(movie);
      } else {
        Movie tMovie = personMovies.firstWhere((element) => element == movie);
        if(movie.job != null) {
          tMovie.character = '${tMovie.character}  ${movie.job}';
        }
      }
    }
    shared.setPersonMoviesData(json.encode(personMovies), personId);

    return personMovies;
  }

  Future<List<Movie>> getTrendingMoviesData() async {
    // print('MovieDataSourceRemote - getTrendingMoviesData()');
    String url = R.urls.trending;

    dynamic data;
    try {
      // print('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url);
      // print('AFTER fetchData()');
    } catch (error) {
      print('MovieDataSourceRemote.getTrendingMoviesData() - ["$error"');
      rethrow;
    }

    List list = data['results'] as List;
    List<Movie> movieList = list.map((e) => Movie.fromJson(e)).toList();
    shared.setTrendingMoviesData(json.encode(movieList));

    return movieList;
  }

  Future<List<Movie>> getPopularMoviesData(int page) async {
    // print('MovieDataSourceRemote - getPopularMoviesData(page: $page)');
    String url = R.urls.popularity;

    Map queryMap = {
      'page': page
    };

    dynamic data;
    try {
      data = await fetchData(url: url, query: queryMap);
    } catch (error) {
      print('MovieDataSourceRemote.getPopularMoviesData() - ["$error"');
      rethrow;
    }

    List list = data['results'] as List;
    List<Movie> movieList = list.map((e) => Movie.fromJson(e)).toList();
    if(page == 1) {
      shared.setPopularMoviesData(json.encode(movieList));
    }

    // print('MovieDataSourceRemote - getPopularMoviesData($page) - RETURN first: ${movieList.first.title}');
    // print('MovieDataSourceRemote - getPopularMoviesData($page) - RETURN ${movieList.length}');
    return movieList;
  }

  Future<List<Movie>> getUpcomingMoviesData(int page) async {
    // print('MovieDataSourceRemote - getUpcomingMoviesData(page: $page)');
    String url = R.urls.upcoming;

    Map queryMap = {
      'page': page
    };

    dynamic data;
    try {
      data = await fetchData(url: url, query: queryMap);
    } catch (error) {
      print('MovieDataSourceRemote.getUpcomingMoviesData() - ["$error"');
      rethrow;
    }

    String dateMinimumStr = data['dates']['minimum'];
    String dateMaximumStr = data['dates']['maximum'];
    DateTime dateMinimum = dateFormat.parse(dateMinimumStr);
    DateTime dateMaximum = dateFormat.parse(dateMaximumStr);
    List list = data['results'] as List;
    List<Movie> movieList = list.map((e) => Movie.fromJson(e)).toList();
    movieList.removeWhere((element) => element.releaseDate?.isBefore(dateMinimum) ?? false);
    movieList.removeWhere((element) => element.releaseDate?.isAfter(dateMaximum) ?? false);

    if(page == 1) {
      shared.setUpcomingMoviesData(json.encode(movieList), '$dateMinimumStr|$dateMaximumStr');
    }

    // print('MovieDataSourceRemote - getUpcomingMoviesData($page) - RETURN first: ${movieList.first.title}');
    // print('MovieDataSourceRemote - getUpcomingMoviesData($page) - RETURN ${movieList.length}');
    return movieList;
  }

  Future<List<MovieGenre>> getGenresData() async {
    // print('MovieDataSourceRemote - getGenresData()');
    String url = R.urls.genres;

    dynamic data;
    try {
      data = await fetchData(url: url);
    } catch (error) {
      print('MovieDataSourceRemote.getGenresData() - ["$error"');
      rethrow;
    }

    List list = data['genres'] as List;
    List<MovieGenre> movieGenresList = list.map((e) => MovieGenre.fromJson(e)).toList();
    shared.setGenresData(json.encode(movieGenresList));

    // print('MovieDataSourceRemote - getGenresData() - RETURN ${movieList.length}');
    return movieGenresList;
  }

  Future<List<Media>> getMultiSearchData(Map map) async {
    // print('MovieDataSourceRemote - getMultiSearchData(map: $map)');
    String url = R.urls.multiSearch;

    String text = map['text'];
    int page = map['page'];

    Map queryMap = {
      'query': text,
      'page': page,
    };

    dynamic data;
    try {
      data = await fetchData(url: url, query: queryMap, timeout: const Duration(minutes: 1));
    } catch (error) {
      print('MovieDataSourceRemote.getMultiSearchData() - ["$error"');
      rethrow;
    }

    List list = data['results'] as List;
    list.removeWhere((element) => element['media_type'] != 'movie' && element['media_type'] != 'person');

    // List<Movie> movieList = list.map((e) => Movie.fromJson(e)).toList();
    List<Media> mediaList = list.map((e) {
      Media media = Media.fromJson(e);

      if(media.mediaType == MediaType.movie) {
        return Movie.fromJson(e);
      } else if (media.mediaType == MediaType.person) {
        // return Person.fromJson(e);
        return Cast.fromJson(e);
      } else {
        return media;
        // return null;
      }
    }).toList();


    // if(page == 1) {
    //   shared.setUpcomingMoviesData(json.encode(movieList));
    // }

    // print('MovieDataSourceRemote - getUpcomingMoviesData($page) - RETURN first: ${movieList.first.title}');
    // print('MovieDataSourceRemote - getUpcomingMoviesData($page) - RETURN ${movieList.length}');
    return mediaList;
  }

  Future<ImdbRating?> getImdbMovieRating(String imdbId) async {
    log('MovieDataSourceRemote - getImdbMovieRating($imdbId)');
    String url = R.urls.imdb(imdbId: imdbId);

    dynamic data;
    try {
      log('TRY BEFORE fetchData(url: "$url")');
      data = await fetchData(url: url);
      log('AFTER fetchData()');
    } catch (error) {
      log('MovieDataSourceRemote.getImdbMovieRating() - catch ($error)');
      if(error.toString().contains('Cannot read properties of undefined')) {
        return null;
      }
      log('MovieDataSourceRemote.getImdbMovieRating() - ["$error"]');
      rethrow;
    }

    log('before ImdbRating.fromJson() - data: "$data"');
    ImdbRating result = ImdbRating.fromJson(data);
    shared.setMovieImdbData(json.encode(result), imdbId);

    log('RETURN MovieDataSourceRemote - getImdbMovieRating()');
    return result;
  }

  /// rangeInBytes='0-100'
  Future<File?> getWorkoutItemFileWithProgress(
      {required String imageUrl,
      required String fileLocalRouteStr,
      bool matchSizeWithOrigin = true,
      Function(int, int)? fn,
      String? rangeInBytes,
      CancelToken? cancelToken}) async {
    File localFile = File(fileLocalRouteStr);

    Options? options;
    if (rangeInBytes != null) {
      // Options options = Options(headers: {'Range': 'bytes=0-0'});
      options = Options(headers: {'Range': 'bytes=$rangeInBytes'});
    }
    var dio = new Dio();
    try {
      await dio.download(imageUrl, fileLocalRouteStr,
          options: options, onReceiveProgress: fn, cancelToken: cancelToken);
    } catch (e) {
      return null;
    }
    return localFile;
  }
}
