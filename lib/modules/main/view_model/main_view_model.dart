import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/providers/user_provider.dart';

import '../../../common/providers/loader_state.dart';
import '../../../common/routes.dart';
import '../../../services/shared_preferences_service.dart';

class MainViewModel extends LoaderViewModel {
  final SharedPreferencesService sharedPreferencesService;
  late UserProvider userProvider;
  // int _servicesToReload = 0;
  // int _servicesToReloaded = 0;

  MainViewModel()
      : sharedPreferencesService = SharedPreferencesService();

  @override
  loadData({BuildContext? context}) async {
    await sharedPreferencesService.initialize();

    userProvider = Provider.of<UserProvider>(context!, listen: false);
    _forceRefreshOnAllRemoteData();

    // sharedPreferencesService.sudoKill();
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

  _forceRefreshOnAllRemoteData() {
    userProvider.loadUserLists();
  }
}
