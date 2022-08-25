import 'dart:convert';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import '../../services/shared_preferences_service.dart';

class UserProvider with ChangeNotifier {
  final SharedPreferencesService _sharedPreferencesService;
  String? fullName;
  String? email;
  String? avatarUrl;
  List<int> favorites = [];
  List<int> watched = [];
  List<int> toWatch = [];
  List<Map<String, dynamic>> rated = [];

  UserProvider()
      : _sharedPreferencesService = SharedPreferencesService();

  void loadUserLists() {
    String? userRatesStr = _sharedPreferencesService.getUserRates();
    String? userFavoritesStr = _sharedPreferencesService.getUserFavorites();
    String? userWatchedStr = _sharedPreferencesService.getUserWatched();
    String? userToWatchStr = _sharedPreferencesService.getUserToWatch();

    List userRates = userRatesStr == null ? [] : json.decode(userRatesStr) as List;
    List userFavorites = userFavoritesStr == null ? [] : json.decode(userFavoritesStr) as List;
    List userWatched = userWatchedStr == null ? [] : json.decode(userWatchedStr) as List;
    List userToWatch = userToWatchStr == null ? [] : json.decode(userToWatchStr) as List;

    rated = List.from(userRates);
    favorites = List.from(userFavorites);
    watched = List.from(userWatched);
    toWatch = List.from(userToWatch);
  }

  // {'id':int,'rate': bool?}
  bool? getMovieRate(int movieId) {
    Map? ratedMovie = rated.firstWhereOrNull((element) => element['id'] == movieId);
    return ratedMovie?['rate'];
  }
  rateMovie(int movieId, bool? rate) {
    bool? movieRate = getMovieRate(movieId);
    print('rateMovie(movieId: "$movieId", rate: "$rate") - movieRate: "$movieRate"');

    if(rate != null) {
      if(movieRate != null) {
        rated.firstWhere((element) => element['id'] == movieId)['rate'] = rate;
      } else {
        rated.add({'id':movieId,'rate': rate});
      }
    } else {
      if(movieRate != null) {
        rated.removeWhere((element) => element['id'] == movieId && element['rate'] == movieRate);
      }
    }
    _sharedPreferencesService.setUserRates(json.encode(rated));
    notifyListeners();
  }

  bool movieIsFavorite(int movieId) {
    return favorites.contains(movieId);
  }
  toggleFavorite(int movieId) {
    if(movieIsFavorite(movieId)) {
      favorites.remove(movieId);
    } else {
      favorites.add(movieId);
    }
    _sharedPreferencesService.setUserFavorites(json.encode(favorites));
    notifyListeners();
  }

  bool movieIsWatched(int movieId) {
    return watched.contains(movieId);
  }
  toggleWatched(int movieId) {
    if(movieIsWatched(movieId)) {
      watched.remove(movieId);
    } else {
      watched.add(movieId);
    }
    _sharedPreferencesService.setUserWatched(json.encode(watched));
    notifyListeners();
  }

  bool movieIsToWatch(int movieId) {
    return toWatch.contains(movieId);
  }
  toggleToWatch(int movieId) {
    if(movieIsToWatch(movieId)) {
      toWatch.remove(movieId);
    } else {
      toWatch.add(movieId);
    }
    _sharedPreferencesService.setUserToWatch(json.encode(toWatch));
    notifyListeners();
  }
}
