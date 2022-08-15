import 'package:flutter/material.dart';
import 'package:watch_this/modules/home/view_model/home_view_model.dart';

import '../modules/home/views/home_page.dart';
import '../modules/main/views/main_page.dart';

export '../modules/main/views/main_page.dart';
export '../modules/home/views/home_page.dart';

const String home = HomePage.route;
final Map<String, Widget Function(BuildContext)> routes = {
  MainPage.route: (context) => MainPage(
        viewModel: MainViewModel(),
      ),
  home: (context) => HomePage(viewModel: HomeViewModel()),
};
  // ..addAll(mapRoutesMap);
