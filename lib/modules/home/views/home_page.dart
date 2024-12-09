import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:watch_this/common/components/movie/views/movie_tile.dart';
import 'package:watch_this/common/components/movie/views/stars_rating.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/common/extensions.dart';
import 'package:watch_this/common/providers/user_provider.dart';
import 'package:watch_this/common/widgets/bottom_navigator_bar.dart';
import 'package:watch_this/common/widgets/r_future_image.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/modules/home/view_model/home_view_model.dart';

import '../../../common/widgets/loading_blur_wdt.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';
  final HomeViewModel viewModel;

  const HomePage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String appTitle = viewModel.translate('APP_NAME');
    String tryAgainStr = viewModel.translate('TRY_AGAIN_TXT');
    final currentTrendingMovieIdNotifier = ValueNotifier<double>(0.0);

    PageController controller = PageController(
      viewportFraction: 1,
      keepPage: true,
      initialPage: 0,
    );

    controller.addListener(() {
      currentTrendingMovieIdNotifier.value =
          controller.page ?? controller.initialPage.toDouble();
    });

    // Color backgroundColor = Colors.black;
    Color backgroundColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(title: Text(appTitle)),
      bottomNavigationBar: BottomNavigatorBar(),
      body: ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService();
              return const LoadingBlurWdt();
            }
            if (viewModel.failed) {
              if(viewModel.trendingListNotifier.value?.isEmpty ?? true) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 128,
                        color: R.colors.accents.rose2,
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: R.colors.accents.rose2,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            viewModel.error?.toString() ?? 'ERROR',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      InkWell(
                        onTap: () => viewModel.loadData(context: context, forceReload: true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: R.colors.accents.rose2,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.refresh,
                                    size: 16.0, color: Colors.black),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  tryAgainStr,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                viewModel.showSnackBarMsg(context: context, msg: viewModel.error?.toString() ?? 'ERROR');
              }
            }

            TextStyle textStyle = Theme.of(context).textTheme.displayMedium!;
            List<Widget> stackList = [];

            Function translate = viewModel.translate;
            String topTrendingMoviesStr =
                translate('TOP_TRENDING_MOVIES_TEXT', param: '10');
            String myMoviesToWatchStr = translate('MY_MOVIES_TO_WATCH_TEXT');
            String popularMoviesStr = translate('POPULAR_MOVIES_TEXT');
            String upcomingMoviesStr = translate('UPCOMING_MOVIES_TEXT');
            String viewAllStr = translate('VIEW_ALL_TEXT');
            String fromStr = translate('FROM_TEXT');
            String toStr = translate('TO_TEXT');

            String? upcomingMoviesDateStr =
                viewModel.sharedPreferencesService.getUpcomingMoviesDataDate();
            String? upcomingMoviesDateHintStr;
            String? dateMinimumStr;
            DateTime? dateMinimumDt;
            if (upcomingMoviesDateStr != null) {
              upcomingMoviesDateHintStr =
                  upcomingMoviesDateStr.replaceAll('|', ' $toStr ');
              upcomingMoviesDateHintStr = '$fromStr $upcomingMoviesDateHintStr';

              String locale = Localizations.localeOf(context).toString();
              locale = locale.split('_').first;
              final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
              final DateFormat dateFormatMonthYear =
                  DateFormat('MMMM y', locale);

              dateMinimumDt =
                  dateFormat.parse(upcomingMoviesDateStr.split('|').first);
              dateMinimumStr =
                  dateFormatMonthYear.format(dateMinimumDt).capitalize();
              dateMinimumStr = '($dateMinimumStr)';
            }

            stackList.add(
              SafeArea(
                child: RefreshIndicator(
                  onRefresh: () =>
                      viewModel.loadData(context: context, forceReload: true),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TRENDING MOVIES PAGE VIEW
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// TRENDING MOVIE IMAGE
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  /// MOVIE BACKDROP IMAGES
                                  ValueListenableBuilder<List<Movie>?>(
                                      valueListenable:
                                          viewModel.trendingListNotifier,
                                      builder: (context, trendingList, _) {
                                        if (trendingList == null) {
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100.0,
                                                height: 100.0,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    key: key ??
                                                        const Key(
                                                            'TRENDING MOVIES circular_loading'),
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.blue
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text('$myMoviesToWatchStr...'),
                                            ],
                                          );
                                        }

                                        if (trendingList.isEmpty) {
                                          return Image.asset(
                                            R.assets.images.defaultBackdropJpeg,
                                            height: 200,
                                            width: 500,
                                            alignment: Alignment.topCenter,
                                            fit: BoxFit.cover,
                                          );
                                        }

                                        return PageView.builder(
                                            itemCount: trendingList.length,
                                            scrollDirection: Axis.horizontal,
                                            controller: controller,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Movie movie =
                                                  trendingList.elementAt(index);
                                              return InkWell(
                                                onTap: () => viewModel
                                                    .navigateToDetails(movie),
                                                child: Stack(
                                                  children: [
                                                    RFutureImage(
                                                      showLoading: false,
                                                      fImage: movie.fBackdrop ??
                                                          movie.fPoster,
                                                      defaultImgWdt: Image.asset(R
                                                          .assets
                                                          .images
                                                          .defaultBackdropJpeg),
                                                      imgSize:
                                                          const Size(0, 200),
                                                      boxFit: BoxFit.cover,
                                                      imgAlignment:
                                                          Alignment.topCenter,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.8),
                                                            Colors.black45,
                                                            backgroundColor
                                                                .withOpacity(
                                                                    0.3),
                                                            backgroundColor
                                                                .withOpacity(
                                                                    0.3),
                                                            backgroundColor,
                                                          ],
                                                          stops: const [
                                                            0.08,
                                                            0.23,
                                                            0.35,
                                                            0.80,
                                                            0.95,
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }),

                                  /// MOVIE DATA [INDEX, TITLE, GENRES, ETC]
                                  IgnorePointer(
                                    child: ValueListenableBuilder<double>(
                                        valueListenable:
                                            currentTrendingMovieIdNotifier,
                                        builder: (context,
                                            currentTrendingMovieId, _) {
                                          const double center = 0.5;
                                          int index =
                                              currentTrendingMovieId.round();

                                          //////////////////////////////////////
                                          Movie movie = viewModel
                                              .trendingListNotifier.value!
                                              .elementAt(index);

                                          String? productionCountries;
                                          if (movie.productionCountries !=
                                                  null &&
                                              movie.productionCountries!
                                                  .isNotEmpty) {
                                            productionCountries = movie
                                                .productionCountries!
                                                .map((e) => e.iso3166_1)
                                                .toList()
                                                .join(', ');
                                          }

                                          List<String?> genres =
                                              movie.genres?.map((e) {
                                                    if (e.name == null ||
                                                        e.name
                                                                .toString()
                                                                .trim() ==
                                                            '') {
                                                      e.name = viewModel
                                                          .userProvider
                                                          .getGenreById(e.id)
                                                          .name;
                                                    }
                                                    return e.name;
                                                  }).toList() ??
                                                  [];
                                          List<Widget> genresWdt = genres
                                              .map((e) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0,
                                                            bottom: 4.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: R
                                                                .colors
                                                                .primaries
                                                                .green1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 2.0),
                                                      child: e == null
                                                          ? const SizedBox()
                                                          : Text(
                                                              e,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: R
                                                                      .colors
                                                                      .primaries
                                                                      .green1),
                                                            ),
                                                    ),
                                                  ))
                                              .toList();
                                          //////////////////////////////////////

                                          int integer =
                                              currentTrendingMovieId.floor();
                                          double rest =
                                              currentTrendingMovieId - integer;
                                          double opacity =
                                              (rest - center).abs() / center;
                                          double offset = center -
                                              (rest > center
                                                  ? (rest - center)
                                                  : (center - rest));

                                          double padding = offset * 50;
                                          offset *= 10;
                                          double size = (1 - opacity) * 0.3;

                                          // if(kDebugMode) {
                                          //   print(
                                          //     'currentTrendingMovieId: $currentTrendingMovieId, '
                                          //         'index: $index, '
                                          //         'integer: $integer, '
                                          //         'rest: $rest, '
                                          //         'padding: $padding, '
                                          //         'offset: $offset, '
                                          //         'opacity: $opacity, '
                                          //         'size: $size'
                                          //     ,);
                                          // }

                                          return Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  /// POSTER
                                                  SizedBox(
                                                    width: 90,
                                                    child: Center(
                                                      child: Transform(
                                                        alignment:
                                                            Alignment.center,
                                                        transform:
                                                            Matrix4.identity()
                                                              ..setEntry(
                                                                  3, 2, 0.003)
                                                              ..rotateY(rest *
                                                                  math.pi)
                                                              ..rotateY(
                                                                  rest > 0.5
                                                                      ? math.pi
                                                                      : 0),
                                                        child: SimpleShadow(
                                                          color: Colors.black,
                                                          offset: const Offset(
                                                              1, 5),
                                                          opacity: 0.4,
                                                          sigma: 3,
                                                          child: RFutureImage(
                                                            // fn: viewModel.expandImage,
                                                            tag: 'TM_',
                                                            fImage:
                                                                movie.fPoster,
                                                            defaultImgWdt:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons
                                                                    .movie_outlined,
                                                                color: Colors
                                                                    .white30,
                                                              ),
                                                            ),
                                                            // imgSize: const Size(80, 120),
                                                            imgSize: Size(
                                                                80 +
                                                                    (size * 80),
                                                                120 +
                                                                    (size *
                                                                        120)),
                                                            boxFit:
                                                                BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      children: [
                                                        /// INDEX
                                                        SizedBox(
                                                          height:
                                                              double.infinity,
                                                          child: FittedBox(
                                                            child: Opacity(
                                                              opacity: opacity,
                                                              child: Transform
                                                                  .translate(
                                                                offset: Offset(
                                                                    rest < center
                                                                        ? -offset
                                                                        : offset,
                                                                    0),
                                                                child: Text(
                                                                  (index + 1)
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        /// MOVIE DATA
                                                        Opacity(
                                                          opacity: opacity,
                                                          child: Transform
                                                              .translate(
                                                            offset: Offset(
                                                                0,
                                                                rest > center
                                                                    ? -padding
                                                                    : padding),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Transform
                                                                    .translate(
                                                                  // offset: Offset(0, rest > center ? (1-opacity) : 60*(1-opacity)),
                                                                  offset: Offset(
                                                                      0,
                                                                      rest > center
                                                                          ? (1 -
                                                                              opacity)
                                                                          : (1 -
                                                                              opacity)),
                                                                  // child: SimpleShadow(
                                                                  //   offset: const Offset(0, 0),
                                                                  //   sigma: 2.0,
                                                                  //   child: Text('${movie.releaseDate!.year}'),
                                                                  // ),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      if (movie
                                                                              .releaseDate !=
                                                                          null)
                                                                        Text(
                                                                          '${movie.releaseDate!.year}',
                                                                        ),
                                                                      if (movie.releaseDate != null &&
                                                                          movie.productionCountries !=
                                                                              null &&
                                                                          movie
                                                                              .productionCountries!
                                                                              .isNotEmpty)
                                                                        const Text(
                                                                          ' | ',
                                                                        ),
                                                                      if (productionCountries !=
                                                                          null)
                                                                        Text(
                                                                            productionCountries),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Transform
                                                                    .translate(
                                                                  // offset: Offset(0, rest > center ? -15*(1-opacity) : 43*(1-opacity)),
                                                                  offset: Offset(
                                                                      0,
                                                                      rest > center
                                                                          ? -15 *
                                                                              (1 -
                                                                                  opacity)
                                                                          : (1 -
                                                                              opacity)),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            FittedBox(
                                                                          child:
                                                                              SimpleShadow(
                                                                            offset:
                                                                                const Offset(0, 0),
                                                                            sigma:
                                                                                2.0,
                                                                            child:
                                                                                StarsRating(rating: movie.voteAverage),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Container(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Transform
                                                                    .translate(
                                                                  // offset: Offset(0, rest > center ? -34*(1-opacity) : 25*(1-opacity)),
                                                                  offset: Offset(
                                                                      0,
                                                                      rest > center
                                                                          ? -34 *
                                                                              (1 -
                                                                                  opacity)
                                                                          : (1 -
                                                                              opacity)),
                                                                  child:
                                                                      SimpleShadow(
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            0),
                                                                    sigma: 2.0,
                                                                    child: Text(
                                                                      movie
                                                                          .title,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayLarge
                                                                          ?.copyWith(
                                                                              fontSize: 20.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 4.0,
                                                                ),
                                                                Transform
                                                                    .translate(
                                                                  offset: Offset(
                                                                      0,
                                                                      rest > center
                                                                          ? -58 *
                                                                              (1 -
                                                                                  opacity)
                                                                          : (1 -
                                                                              opacity)),
                                                                  child:
                                                                      SimpleShadow(
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            0),
                                                                    sigma: 2.0,
                                                                    child: Wrap(
                                                                        children:
                                                                            genresWdt),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),

                                  /// TRENDING LABEL
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 16.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.trending_up,
                                              color: textStyle.color,
                                              size: textStyle.fontSize),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            topTrendingMoviesStr,
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// TRENDING MOVIE PAGE INDICATOR
                            SizedBox(
                              height: 20,
                              child: ValueListenableBuilder<List<Movie>?>(
                                  valueListenable:
                                      viewModel.trendingListNotifier,
                                  builder: (context, trendingList, _) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: SmoothPageIndicator(
                                        controller: controller,
                                        count: trendingList?.length ?? 0,
                                        // effect: ScrollingDotsEffect(
                                        effect: ExpandingDotsEffect(
                                          activeDotColor:
                                              Theme.of(context).primaryColor,
                                          // maxVisibleDots: 5,
                                          // activeDotScale: 1.5,
                                          dotHeight: 12.0,
                                          dotWidth: 12.0,
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),

                        /// MY MOVIES TO WATCH LIST
                        Consumer<UserProvider>(
                            builder: (context, userProvider, _) {
                          viewModel
                              .getMyMovieDataList(
                                  movieIdList: userProvider.toWatch)
                              .then((value) {
                            viewModel.updateMediaFiles(
                                myMovies: true,
                                popular: false,
                                trending: false,
                                upcoming: false);
                          });
                          return ValueListenableBuilder<List<Movie>?>(
                              valueListenable: viewModel.myMoviesListNotifier,
                              builder: (context, myMoviesToWatch, _) {
                                if (myMoviesToWatch == null) {
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
                                      Text('$myMoviesToWatchStr...'),
                                    ],
                                  );
                                }

                                if (myMoviesToWatch.isEmpty) {
                                  return Container();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(myMoviesToWatchStr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: myMoviesToWatch
                                              .map((e) =>
                                                  ChangeNotifierProvider<
                                                      Movie>.value(
                                                    value: e,
                                                    child: MovieTile(
                                                      showToWatchIcon: false,
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                  ],
                                );
                              });
                        }),

                        /// POPULAR MOVIES
                        ValueListenableBuilder<List<Movie>?>(
                            valueListenable: viewModel.popularListNotifier,
                            builder: (context, popularList, _) {
                              if (popularList == null) {
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
                                    Text('$popularMoviesStr...'),
                                  ],
                                );
                              }

                              if (popularList.isEmpty) {
                                return Container();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(popularMoviesStr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: InkWell(
                                            onTap: viewModel
                                                .navigateToPopularViewAll,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 8.0),
                                              child: Text(
                                                viewAllStr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: popularList.map((e) {
                                          return ChangeNotifierProvider<
                                              Movie>.value(
                                            value: e,
                                            child: MovieTile(),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              );
                            }),

                        /// UPCOMING MOVIES
                        ValueListenableBuilder<List<Movie>?>(
                            valueListenable:
                                viewModel.upcomingMoviesListNotifier,
                            builder: (context, upcomingList, _) {
                              if (upcomingList == null) {
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
                                    Text('$upcomingMoviesStr...'),
                                  ],
                                );
                              }

                              if (upcomingList.isEmpty) {
                                return Container();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(upcomingMoviesStr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge),
                                        if (upcomingMoviesDateStr != null)
                                          Expanded(
                                            child: FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.scaleDown,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Tooltip(
                                                  message:
                                                      upcomingMoviesDateHintStr,
                                                  child: Text(dateMinimumStr!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: InkWell(
                                            onTap: viewModel
                                                .navigateToUpcomingViewAll,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 8.0),
                                              child: Text(viewAllStr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: upcomingList
                                            .map((e) => ChangeNotifierProvider<
                                                    Movie>.value(
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
                      ],
                    ),
                  ),
                ),
              ),
            );

            if (viewModel.loading) {
              stackList.add(
                const LoadingBlurWdt(),
              );
            }

            return Stack(
              children: stackList,
            );
          },
        ),
      ),
    );
  }
}
