import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_this/common/extensions.dart';

enum SharePrefsAttribute {
  itsFirstTime,
  userLocale,
  userRates,
  userFavorites,
  userWatched,
  userToWatch,
  checkedMediaData,
  extendedMovie,
  extendedMovieImdb,
  extendedMovieCast,
  extendedMovieCrew,
  collectionMovies,
  personMovies,
  trendingMovies,
  trendingMoviesDate,
  popularMovies,
  popularMoviesDate,
  upcomingMovies,
  upcomingMoviesDate,
  genres,
}

extension ParseToString on SharePrefsAttribute {
  String toShortString() {
    return toString().split('.').last.toLowerCase();
  }
}

class SharedPreferencesService {
  /// singleton boilerplate
  static final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _sharedPreferencesService;
  }

  SharedPreferencesService._internal();
  /// singleton boilerplate

  late SharedPreferences _prefs;

  Future initialize() async => _prefs = await SharedPreferences.getInstance();

  sudoKill() => _prefs.clear();

  /// CHECK IF IT'S FIRST TIME
  bool getItsFirstTime() => _prefs.getBool(SharePrefsAttribute.itsFirstTime.toShortString()) ?? true;

  void setItsFirstTime(bool value) {
    _prefs.setBool(SharePrefsAttribute.itsFirstTime.toShortString(), value);
  }

  /// USER LOCALE
  String? getUserLocale() {
    return _prefs.getString(SharePrefsAttribute.userLocale.toShortString());
  }

  void setUserLocale(String value) {
    _prefs.setString(SharePrefsAttribute.userLocale.toShortString(), value);
  }

  void removeUserLocale() {
    _prefs.remove(SharePrefsAttribute.userLocale.toShortString());
  }

  /// USER MOVIE LISTS
  String? getUserRates() {
    return _prefs.getString(SharePrefsAttribute.userRates.toShortString());
  }
  void setUserRates(String value) {
    // _prefs.remove(SharePrefsAttribute.userRates.toShortString());
    _prefs.setString(SharePrefsAttribute.userRates.toShortString(), value);
  }

  String? getUserFavorites() {
    return _prefs.getString(SharePrefsAttribute.userFavorites.toShortString());
  }
  void setUserFavorites(String value) {
    _prefs.setString(SharePrefsAttribute.userFavorites.toShortString(), value);
  }

  String? getUserWatched() {
    return _prefs.getString(SharePrefsAttribute.userWatched.toShortString());
  }
  void setUserWatched(String value) {
    _prefs.setString(SharePrefsAttribute.userWatched.toShortString(), value);
  }

  String? getUserToWatch() {
    return _prefs.getString(SharePrefsAttribute.userToWatch.toShortString());
  }
  void setUserToWatch(String value) {
    _prefs.setString(SharePrefsAttribute.userToWatch.toShortString(), value);
  }

  /// CHECKED MEDIA
  List<String> getCheckedMediaData() {

    List<String> list = [];
    String? checkedMediaStr = _prefs.getString(SharePrefsAttribute.checkedMediaData.toShortString());
    if(checkedMediaStr != null) {
      List tList = json.decode(checkedMediaStr) as List;
      list = List.from(tList);
    }
    return list;
  }

  void addCheckedMediaData(String localFilePath) {
    Set<String> list = getCheckedMediaData().toSet();
    list.add(localFilePath);
    _prefs.setString(SharePrefsAttribute.checkedMediaData.toShortString(), json.encode(list.toList()));
  }

  /// EXTENDED MOVIE - DETAILS
  String? getExtendedMovieData(int movieId) {
    // _prefs.clear();
    // return null;
    return _prefs.getString('${SharePrefsAttribute.extendedMovie.toShortString()}_$movieId');
  }

  void setExtendedMovieData(String value, int movieId) {
    _prefs.setString('${SharePrefsAttribute.extendedMovie.toShortString()}_$movieId', value);
  }

  /// EXTENDED MOVIE - IMDb
  String? getMovieImdbData(String imdbId) {
    return _prefs.getString('${SharePrefsAttribute.extendedMovieImdb.toShortString()}_$imdbId');
  }

  void setMovieImdbData(String value, String imdbId) {
    _prefs.setString('${SharePrefsAttribute.extendedMovieImdb.toShortString()}_$imdbId', value);
  }

  /// EXTENDED MOVIE - CREDITS
  String? getExtendedMovieCastData(int movieId) {
    return _prefs.getString('${SharePrefsAttribute.extendedMovieCast.toShortString()}_$movieId');
  }
  String? getExtendedMovieCrewData(int movieId) {
    return _prefs.getString('${SharePrefsAttribute.extendedMovieCrew.toShortString()}_$movieId');
  }

  void setExtendedMovieCastData(String value, int movieId) {
    _prefs.setString('${SharePrefsAttribute.extendedMovieCast.toShortString()}_$movieId', value);
  }
  void setExtendedMovieCrewData(String value, int movieId) {
    _prefs.setString('${SharePrefsAttribute.extendedMovieCrew.toShortString()}_$movieId', value);
  }

  /// EXTENDED PERSON - MOVIES
  String? getPersonMoviesData(int personId) {
    return _prefs.getString('${SharePrefsAttribute.personMovies.toShortString()}_$personId');
  }

  void setPersonMoviesData(String value, int personId) {
    _prefs.setString('${SharePrefsAttribute.personMovies.toShortString()}_$personId', value);
  }

  /// COLLECTION - MOVIES
  String? getCollectionMoviesData(int collectionId) {
    return _prefs.getString('${SharePrefsAttribute.collectionMovies.toShortString()}_$collectionId');
  }

  void setCollectionMoviesData(String value, int collectionId) {
    _prefs.setString('${SharePrefsAttribute.collectionMovies.toShortString()}_$collectionId', value);
  }

  /// TRENDING MOVIES
  String? getTrendingMoviesDataDate() {
    return _prefs.getString(SharePrefsAttribute.trendingMoviesDate.toShortString());
  }

  String? getTrendingMoviesData() {
    return _prefs.getString(SharePrefsAttribute.trendingMovies.toShortString());
  }

  void setTrendingMoviesData(String value) {
    _prefs.setString(SharePrefsAttribute.trendingMovies.toShortString(), value);
    _prefs.setString(SharePrefsAttribute.trendingMoviesDate.toShortString(), DateTime.now().toTimeStamp.toString());
  }

  /// POPULAR MOVIES
  String? getPopularMoviesDataDate() {
    return _prefs.getString(SharePrefsAttribute.popularMoviesDate.toShortString());
  }

  String? getPopularMoviesData() {
    return _prefs.getString(SharePrefsAttribute.popularMovies.toShortString());
  }

  void setPopularMoviesData(String value) {
    _prefs.setString(SharePrefsAttribute.popularMovies.toShortString(), value);
    _prefs.setString(SharePrefsAttribute.popularMoviesDate.toShortString(), DateTime.now().toTimeStamp.toString());
  }

  /// UPCOMING MOVIES
  String? getUpcomingMoviesDataDate() {
    return _prefs.getString(SharePrefsAttribute.upcomingMoviesDate.toShortString());
  }

  String? getUpcomingMoviesData() {
    return _prefs.getString(SharePrefsAttribute.upcomingMovies.toShortString());
  }

  void setUpcomingMoviesData(String value, String minMaxDates) {
    _prefs.setString(SharePrefsAttribute.upcomingMovies.toShortString(), value);
    // _prefs.setString(SharePrefsAttribute.upcomingMoviesDate.toShortString(), DateTime.now().toTimeStamp.toString());
    _prefs.setString(SharePrefsAttribute.upcomingMoviesDate.toShortString(), minMaxDates);
  }

  /// GENRES
  String? getGenresData() {
    return _prefs.getString(SharePrefsAttribute.genres.toShortString());
  }

  void setGenresData(String value) {
    _prefs.setString(SharePrefsAttribute.genres.toShortString(), value);
  }
}
