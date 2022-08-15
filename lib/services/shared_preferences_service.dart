import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_this/common/extensions.dart';

enum SharePrefsAttribute {
  itsFirstTime,
  userLocale,
  checkedMediaData,
  trendingMovies,
  trendingMoviesDate,
  popularMovies,
  popularMoviesDate,
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
  // SharedPreferences get prefs => _prefs;

  Future initialize() async => _prefs = await SharedPreferences.getInstance();

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
}
