import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../../../common/providers/loader_state.dart';
import '../../../common/routes.dart';
import '../../../services/shared_preferences_service.dart';

class MainViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  // int _servicesToReload = 0;
  // int _servicesToReloaded = 0;

  MainViewModel()
      : sharedPreferencesService = SharedPreferencesService();

  @override
  loadData({BuildContext? context}) async {
    await sharedPreferencesService.initialize();

    _forceRefreshOnAllRemoteData();

    bool itsFirstTime = sharedPreferencesService.getItsFirstTime();
    if (kDebugMode) {
      print('MainViewModel - loadData() - itsFirstTime: $itsFirstTime');
    }

    // if (itsFirstTime) {
    //   sharedPreferencesService.setItsFirstTime(false);
    //   navigator.toRoute(OnBoardingPage.route, pushAndReplace: true);
    // } else {
    //   navigator.toRoute(HomePage.route, pushAndReplace: true);
      navigator.toRoute(HomePage.route, pushAndReplace: true);
    // }
  }

  _forceRefreshOnAllRemoteData() {}
}
