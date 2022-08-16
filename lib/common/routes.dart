import 'package:flutter/material.dart';
import 'package:watch_this/modules/home/view_model/home_view_model.dart';

import '../modules/main/views/main_page.dart';
import '../modules/home/views/home_page.dart';
import 'components/movie/view_model/movie_details_view_model.dart';
import 'components/movie/views/movie_details_page.dart';

export '../modules/main/views/main_page.dart';
export '../modules/home/views/home_page.dart';
export 'components/movie/views/movie_details_page.dart';

const String home = HomePage.route;
const String movie = MovieDetailsPage.route;

final Map<String, Widget Function(BuildContext)> routes = {
  MainPage.route: (context) => MainPage(
        viewModel: MainViewModel(),
      ),
  home: (context) => HomePage(viewModel: HomeViewModel()),
  movie: (context) => MovieDetailsPage(viewModel: MovieDetailsViewModel()),
};
  // ..addAll(mapRoutesMap);
