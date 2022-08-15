import 'package:flutter/material.dart';
import '../../services/shared_preferences_service.dart';

class UserProvider with ChangeNotifier {
  final SharedPreferencesService _sharedPreferencesService;
  String? fullName;
  String? email;
  String? avatarUrl;

  UserProvider()
      : _sharedPreferencesService = SharedPreferencesService();
}
