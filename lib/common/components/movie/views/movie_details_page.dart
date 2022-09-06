import 'dart:ui';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/components/person/views/person_tile.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/common/providers/user_provider.dart';
import 'package:watch_this/common/widgets/bottom_navigator_bar.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/person.dart';
import '../../../widgets/loading_blur_wdt.dart';
import '../../../widgets/r_future_image.dart';
import '../view_model/movie_details_view_model.dart';
import 'movie_tile.dart';
import 'stars_rating.dart';

class MovieDetailsPage extends StatelessWidget {
  static const String route = '/movie_details';
  final MovieDetailsViewModel viewModel;

  const MovieDetailsPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<MovieDetailsViewModel>(builder: (context, viewModel, _) {
        if (viewModel.normal) {
          viewModel.scheduleLoadService(context: context);
          return const LoadingBlurWdt();
        }

        String locale = Localizations.localeOf(context).toString();
        locale = locale.split('_').first;

        double blur = 3.0;

        String? tagline;
        if (viewModel.movie!.tagline != null &&
            viewModel.movie!.tagline!.trim() != '') {
          tagline = viewModel.movie!.tagline!.trim();
        }

        // String locale = Localizations.localeOf(navigator.context).toString();
        // final DateFormat dateFormat = DateFormat('dd MMMM yyyy', locale);
        final DateFormat dateFormat = DateFormat.yMMMMd(locale);
        DateTime? releaseDateDt = viewModel.movie!.releaseDate;
        String? releaseDateStr;
        if(releaseDateDt != null) {
          releaseDateStr = dateFormat.format(releaseDateDt);
        }

        String movieDurationStr = printDuration(
          viewModel.movie?.runtime ?? const Duration(seconds: 0),
          abbreviated: true,
          locale: DurationLocale.fromLanguageCode(locale)!,
        );

        List<String?> genres =
            viewModel.movie!.genres?.map((e) => e.name).toList() ?? [];
        // String genresStr = genres.join(' / ');
        List<Widget> genresWdt = genres
            .map((e) => Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: R.colors.primary),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: e == null
                        ? const SizedBox()
                        : Text(
                            e,
                            style: TextStyle(color: R.colors.primary),
                          ),
                  ),
                ))
            .toList();

        IconData? movieStatus = viewModel.movie!.getStatusIcon();

        String? productionCountries;
        if (viewModel.movie!.productionCountries != null &&
            viewModel.movie!.productionCountries!.isNotEmpty) {
          productionCountries = viewModel.movie!.productionCountries!
              .map((e) => e.iso3166_1)
              .toList()
              .join(', ');
        }

        print('MovieDetailsPage - movie: ${viewModel.movie!.id} - ${viewModel.movie!.title}');
        _onSelect(fn) => fn();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            // title: const Text('DETAILS'),
            actions: [
              Consumer<UserProvider>(builder: (context, provider, _) {
                bool? movieIsLike = provider.getMovieRate(viewModel.movie!.id);
                bool movieIsWatched =
                    provider.movieIsWatched(viewModel.movie!.id);
                bool movieIsToWatch =
                    provider.movieIsToWatch(viewModel.movie!.id);
                bool movieIsFavorite =
                    provider.movieIsFavorite(viewModel.movie!.id);
                return Row(
                  children: [
                    IconButton(
                      tooltip: 'RATE',
                      onPressed: () => provider.rateMovie(
                          viewModel.movie!.id,
                          movieIsLike == null
                              ? true
                              : movieIsLike
                                  ? false
                                  : null),
                      icon: Icon(
                          movieIsLike == null
                              ? Icons.thumbs_up_down_outlined
                              : movieIsLike
                                  ? Icons.thumb_up
                                  : Icons.thumb_down,
                          color:
                              (movieIsLike ?? false) ? R.colors.primary : null),
                    ),
                    IconButton(
                      tooltip: movieIsFavorite
                          ? 'REMOVE FROM "FAVORITES"'
                          : 'ADD TO "FAVORITES"',
                      onPressed: () =>
                          provider.toggleFavorite(viewModel.movie!.id),
                      icon: Icon(
                          movieIsFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              movieIsFavorite ? R.colors.accents.rose1 : null),
                    ),
                    PopupMenuButton(
                      onSelected: viewModel.loading ? null : _onSelect,
                      child: viewModel.loading
                          ? Container()
                          : const Icon(Icons.menu),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            height: 0.0,
                            value: () =>
                                provider.toggleToWatch(viewModel.movie!.id),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icon(movieIsToWatch
                                  //     ? Icons.playlist_add_circle
                                  //     : Icons.playlist_add_circle_outlined),
                                  Icon(movieIsToWatch
                                      ? Icons.remove_red_eye
                                      : Icons.remove_red_eye_outlined),
                                  const SizedBox(width: 8.0),
                                  const Text('TO WATCH'),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            height: 0.0,
                            value: () =>
                                provider.toggleWatched(viewModel.movie!.id),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(movieIsWatched
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline),
                                  const SizedBox(width: 8.0),
                                  const Text('WATCHED'),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                  ],
                );
              }),
            ],
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          bottomNavigationBar: BottomNavigatorBar(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => viewModel.loadData(context: context, forceReload: true),
              child: Stack(
                children: [
                  /// BACKDROP IMAGE AND GRADIENT
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      RFutureImage(
                        showLoading: false,
                        fImage: viewModel.movie!.fBackdrop ??
                            viewModel.movie!.fPoster,
                        defaultImgWdt:
                            Image.asset(R.assets.images.defaultBackdropJpeg),
                        imgSize: const Size(0, 300),
                        boxFit: BoxFit.cover,
                        imgAlignment: Alignment.topCenter,
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                        child: const SizedBox(),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black45,
                              Colors.black,
                            ],
                            stops: [
                              0.02,
                              0.12,
                              0.25,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER [TITLE, POSTER, BACKDROP,ETC]
                          Row(
                            children: [
                              /// POSTER
                              RFutureImage(
                                fn: viewModel.expandImage,
                                fImage: viewModel.movie!.fPoster,
                                defaultImgWdt: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.movie_outlined,
                                    color: Colors.white30,
                                  ),
                                ),
                                // imgSize: 100.0,
                                imgSize: const Size(100, 150),
                                boxFit: BoxFit.cover,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      viewModel.movie!.title,
                                      // viewModel.movie!.title + ' ' + viewModel.movie!.title + ' ',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    if (viewModel.movie!.originalTitle !=
                                        viewModel.movie!.title)
                                      Text(
                                        viewModel.movie!.originalTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12.0,
                                            ),
                                      ),
                                    if (movieStatus != null)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(movieStatus,
                                                  size: Theme.of(context)
                                                      .textTheme
                                                      .headline2
                                                      ?.fontSize,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline2
                                                      ?.color),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                '${viewModel.movie!.status}',
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (tagline != null)
                                      Text(
                                        '"$tagline"',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        if (viewModel.movie!.releaseDate != null)
                                          Tooltip(
                                            message: releaseDateStr,
                                            child: Text(
                                              '${viewModel.movie!.releaseDate!.year}',
                                            ),
                                          ),
                                        if (viewModel.movie!.releaseDate !=
                                                null &&
                                            viewModel
                                                    .movie!.productionCountries !=
                                                null &&
                                            viewModel.movie!.productionCountries!
                                                .isNotEmpty)
                                          const Text(
                                            ' | ',
                                          ),
                                        if (productionCountries != null)
                                          Text(productionCountries),
                                      ],
                                    ),
                                    if (viewModel.movie!.voteCount > 0)
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: FittedBox(
                                              child: StarsRating(
                                                  rating: viewModel
                                                      .movie!.voteAverage),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16.0,
                                          ),
                                          // const Expanded(child: SizedBox()),
                                          (viewModel.movie!.certifications ==
                                                      null ||
                                                  viewModel.movie!.certifications!
                                                      .isEmpty)
                                              ? const Expanded(child: SizedBox())
                                              : Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: R.colors.primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8.0,
                                                                  vertical: 2.0),
                                                          child: Text(
                                                            viewModel.movie!
                                                                .certifications!
                                                                .join(' | '),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: R.colors
                                                                    .background),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          // Expanded(
                                          //   flex: 1,
                                          //   child: viewModel.movie!.voteAverage ==
                                          //           0.0
                                          //       ? const SizedBox()
                                          //       : Container(
                                          //           decoration: BoxDecoration(
                                          //             color: R.colors.accents.rose2,
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     8.0),
                                          //           ),
                                          //           child: Padding(
                                          //             padding: const EdgeInsets
                                          //                     .symmetric(
                                          //                 vertical: 2.0,
                                          //                 horizontal: 8.0),
                                          //             child: FittedBox(
                                          //               fit: BoxFit.scaleDown,
                                          //               child: Text(
                                          //                 'imdb: ${viewModel.movie!.voteAverage.toStringAsFixed(2)}',
                                          //               ),
                                          //             ),
                                          //           ),
                                          //         ),
                                          // ),
                                        ],
                                      ),
                                    if (movieDurationStr != '0s')
                                      Text(movieDurationStr),
                                    // Text(genresStr),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Wrap(
                                        children: genresWdt,
                                      ),
                                    ),
                                    // if (viewModel.movie!.certifications != null &&
                                    //     viewModel
                                    //         .movie!.certifications!.isNotEmpty)
                                    //   Container(
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.blue,
                                    //       borderRadius:
                                    //           BorderRadius.circular(8.0),
                                    //     ),
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 8.0, vertical: 2.0),
                                    //       child: Text(
                                    //         viewModel.movie!.certifications!
                                    //             .join(' | '),
                                    //         style: const TextStyle(
                                    //             fontWeight: FontWeight.bold),
                                    //       ),
                                    //     ),
                                    //   ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (viewModel.movie!.watchProvidersList == null)
                            const SizedBox(height: 16.0),

                          /// WATCH PROVIDERS
                          if (viewModel.movie!.watchProvidersList != null)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: viewModel
                                          .movie!.watchProvidersList!
                                          .map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, right: 16.0),
                                                child: Tooltip(
                                                  message: e.providerName,
                                                  child: GridItemWdt(
                                                    tag: e.providerName,
                                                    fImage: e.fLogo,
                                                    fImageDefault:
                                                        Icons.account_balance,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    itemWidth: 40,
                                                    itemHeight: 40,
                                                    // imageSize: const Size(40, 40),
                                                    imagePadding: 0.0,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),

                          /// STORYLINE
                          if (viewModel.movie!.overview.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('STORYLINE',
                                    style: Theme.of(context).textTheme.headline1),
                                const SizedBox(height: 8.0),
                                Text(viewModel.movie!.overview),
                                const SizedBox(height: 16.0),
                              ],
                            ),

                          /// CREDITS
                          ValueListenableBuilder<List<Person>?>(
                              valueListenable: viewModel.movieCreditsNotifier,
                              builder: (context, movieCredits, _) {
                                if (movieCredits == null) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100.0,
                                        height: 100.0,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            key: key ??
                                                const Key('circular_loading'),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.blue.withOpacity(0.6),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text('CREDITS...'),
                                    ],
                                  );
                                }

                                if (movieCredits.isEmpty) {
                                  return Container();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('CREDITS',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    Material(
                                      color: Colors.transparent,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: movieCredits
                                              .map((e) => PersonTile(
                                                    fn: () => viewModel
                                                        .navigateToPersonDetails(
                                                            e),
                                                    person: e,
                                                  ))
                                              //     .map((e) => GridItemWdt(
                                              //   fn: () => viewModel
                                              //       .navigateToPersonDetails(
                                              //       e),
                                              //   title: e.name,
                                              //   subTitle: e.job,
                                              //   fImage: e.fProfile,
                                              // ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                  ],
                                );
                              }),

                          /// COLLECTION
                          ValueListenableBuilder<List<Movie>?>(
                              valueListenable: viewModel.collectionMoviesNotifier,
                              builder: (context, collectionMovies, _) {
                                if (collectionMovies == null) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100.0,
                                        height: 100.0,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            key: key ??
                                                const Key('circular_loading'),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.blue.withOpacity(0.6),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text('COLLECTION...'),
                                    ],
                                  );
                                }

                                if (collectionMovies.isEmpty) {
                                  return Container();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('COLLECTION',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    Material(
                                      color: Colors.transparent,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: collectionMovies
                                              .map((e) => ChangeNotifierProvider<Movie>.value(
                                                value: e,
                                                child: MovieTile(),
                                              ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                  ],
                                );
                              }),

                          /// PRODUCTION COMPANIES
                          // if (viewModel.movie!.productionCompanies != null)
                          //   Column(
                          //     mainAxisSize: MainAxisSize.min,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text('PRODUCTION COMPANIES',
                          //           style: Theme.of(context).textTheme.headline1),
                          //       Material(
                          //         color: Colors.transparent,
                          //         child: SingleChildScrollView(
                          //           scrollDirection: Axis.horizontal,
                          //           child: Row(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: viewModel
                          //                 .movie!.productionCompanies!
                          //                 .map((e) => Padding(
                          //                       padding:
                          //                           const EdgeInsets.all(8.0),
                          //                       child: Tooltip(
                          //                         message: e.name,
                          //                         child: GridItemWdt(
                          //                           fImage: e.fLogo,
                          //                           fImageDefault:
                          //                               Icons.account_balance,
                          //                           itemWidth: 60,
                          //                           imageSize: const Size(60, 60),
                          //                           imagePadding: 0.0,
                          //                         ),
                          //                       ),
                          //                     ))
                          //                 //     !.map((e) => GridItemWdt(
                          //                 //   title: e.name,
                          //                 //   fImage: e.fLogo,
                          //                 //   fImageDefault: Icons.account_balance,
                          //                 // ))
                          //                 .toList(),
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(height: 16.0),
                          //     ],
                          //   ),

                          /// SIMILAR MOVIES
                          if (viewModel.movie!.similarMovies != null &&
                              viewModel.movie!.similarMovies!.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SIMILAR MOVIES',
                                    style: Theme.of(context).textTheme.headline1),
                                Material(
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: viewModel.movie!.similarMovies!
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Tooltip(
                                                  message: e.title,
                                                  child: ChangeNotifierProvider<Movie>.value(
                                                    value: e,
                                                    child: MovieTile(),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
