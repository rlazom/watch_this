import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:watch_this/models/cast.dart';
import 'package:watch_this/models/crew.dart';
import 'package:watch_this/models/movie_genre.dart';

import '../../../common/constants.dart';
import '../../../models/movie.dart';
import '../../r_master/data_sources/r_master_data_source_remote.dart';

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
      data = await fetchData(url: url);
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

  Future<List<Movie>> getPopularMoviesData() async {
    // print('MovieDataSourceRemote - getPopularMoviesData()');
    String url = R.urls.popularity;

    dynamic data;
    try {
      data = await fetchData(url: url);
    } catch (error) {
      print('MovieDataSourceRemote.getPopularMoviesData() - ["$error"');
      rethrow;
    }

    List list = data['results'] as List;
    List<Movie> movieList = list.map((e) => Movie.fromJson(e)).toList();
    shared.setPopularMoviesData(json.encode(movieList));

    // print('MovieDataSourceRemote - getPopularMoviesData() - RETURN ${movieList.length}');
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
