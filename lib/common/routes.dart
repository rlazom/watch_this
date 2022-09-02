import 'package:flutter/material.dart';
import 'package:watch_this/modules/home/view_model/home_view_model.dart';

import '../modules/main/views/main_page.dart';
import '../modules/home/views/home_page.dart';
import 'components/movie/view_model/movie_details_view_model.dart';
import 'components/movie/views/movie_details_page.dart';
import 'components/movies/view_model/movies_view_model.dart';
import 'components/movies/views/movies_page.dart';
import 'components/person/view_model/person_details_view_model.dart';
import 'components/person/views/person_details_page.dart';

export '../modules/main/views/main_page.dart';
export '../modules/home/views/home_page.dart';
export 'components/movie/views/movie_details_page.dart';
export 'components/person/views/person_details_page.dart';

const String home = HomePage.route;
const String routeMoviesPage = MoviesPage.route;
const String routeMovieDetails = MovieDetailsPage.route;
const String routePersonDetails = PersonDetailsPage.route;

final Map<String, Widget Function(BuildContext)> routes = {
  MainPage.route: (context) => MainPage(
        viewModel: MainViewModel(),
      ),
  home: (context) => HomePage(viewModel: HomeViewModel()),
  routeMoviesPage: (context) => MoviesPage(viewModel: MoviesViewModel()),
  routeMovieDetails: (context) => MovieDetailsPage(viewModel: MovieDetailsViewModel()),
  routePersonDetails: (context) => PersonDetailsPage(viewModel: PersonDetailsViewModel()),
};
  // ..addAll(mapRoutesMap);
