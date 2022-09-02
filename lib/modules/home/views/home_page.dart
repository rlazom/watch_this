import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:watch_this/common/components/movie/views/movie_tile.dart';
import 'package:watch_this/common/components/movie/views/stars_rating.dart';
import 'package:watch_this/common/constants.dart';
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
    final currentTrendingMovieIdNotifier = ValueNotifier<double>(0.0);

    PageController controller = PageController(
      viewportFraction: 1,
      keepPage: true,
      initialPage: 0,
    );
    // if (controller.hasListeners) {
    //   controller.removeListener(() {
    //     currentTrendingMovieIdNotifier.value =
    //         controller.page ?? controller.initialPage.toDouble();
    //   });
    // }
    controller.addListener(() {
      currentTrendingMovieIdNotifier.value =
          controller.page ?? controller.initialPage.toDouble();
    });

    // Color backgroundColor = Colors.black;
    Color backgroundColor = Theme.of(context).backgroundColor;

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
                  ],
                ),
              );
            }

            TextStyle textStyle = Theme.of(context).textTheme.headline2!;
            List<Widget> stackList = [];

            Function translate = viewModel.translate;
            String topTrendingMoviesStr =
                translate('TOP_TRENDING_MOVIES_TEXT', param: '10');
            String myMoviesToWatchStr = translate('MY_MOVIES_TO_WATCH_TEXT');
            String popularMoviesStr = translate('POPULAR_MOVIES_TEXT');
            String viewAllStr = translate('VIEW_ALL_TEXT');

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

                                  /// MOVIE INDEX
                                  IgnorePointer(
                                    child: ValueListenableBuilder<double>(
                                        valueListenable:
                                            currentTrendingMovieIdNotifier,
                                        builder: (context,
                                            currentTrendingMovieId, _) {
                                          const double centerOffset = 0.023148;
                                          const double center =
                                              centerOffset + 0.5;
                                          int index = (currentTrendingMovieId -
                                                  centerOffset)
                                              .round();

                                          //////////////////////////////////////
                                          Movie movie = viewModel
                                              .trendingListNotifier.value!
                                              .elementAt(index);

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
                                          double padding = offset * 100;
                                          padding -= rest > center ? 4 : 0;
                                          offset *= 10;
                                          offset -= rest > center ? 0.47 : 0;

                                          // print('currentTrendingMovieId: $currentTrendingMovieId, '
                                          //     'index: $index, '
                                          //     'integer: $integer, '
                                          //     'rest: $rest, ${rest * 3.15}, '
                                          //     'padding: $padding, '
                                          //     'offset: $offset, '
                                          //     'OPACITY: $opacity'
                                          //   ,);

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
                                                  Transform(
                                                    alignment: Alignment.center,
                                                    transform:
                                                        Matrix4.identity()
                                                          ..setEntry(
                                                              3, 2, 0.003)
                                                          ..rotateY(rest * 3.15)
                                                          ..rotateY(rest > 0.5
                                                              ? math.pi
                                                              : 0),
                                                    child: SimpleShadow(
                                                      color: Colors.black,
                                                      offset:
                                                          const Offset(1, 5),
                                                      opacity: 0.4,
                                                      sigma: 3,
                                                      child: RFutureImage(
                                                        // fn: viewModel.expandImage,
                                                        tag: 'TM_',
                                                        fImage: movie.fPoster,
                                                        defaultImgWdt:
                                                            const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons
                                                                .movie_outlined,
                                                            color:
                                                                Colors.white30,
                                                          ),
                                                        ),
                                                        imgSize:
                                                            const Size(80, 120),
                                                        boxFit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(
                                                    width: 16.0,
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
                                                              child: Transform.translate(
                                                                offset: Offset(rest < center ? -offset : offset,0),
                                                                child: Text(
                                                                  (index + 1)
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        Opacity(
                                                          opacity: opacity,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                top: rest <
                                                                        center
                                                                    ? padding
                                                                    : 0,
                                                                bottom: rest >
                                                                        center
                                                                    ? padding
                                                                    : 0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    '${movie.releaseDate!.year}'),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          FittedBox(
                                                                        child: StarsRating(
                                                                            rating:
                                                                                movie.voteAverage),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Container(),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  movie.title,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline1
                                                                      ?.copyWith(
                                                                          fontSize:
                                                                              20.0),
                                                                ),
                                                                const SizedBox(
                                                                  height: 4.0,
                                                                ),
                                                                Wrap(
                                                                    children:
                                                                        genresWdt)
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
                        ValueListenableBuilder<List<Movie>?>(
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
                                            .headline1),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: myMoviesToWatch
                                            .map((e) => MovieTile(
                                                  fn: () => viewModel
                                                      .navigateToDetails(e),
                                                  movie: e,
                                                  showToWatchIcon: false,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              );
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
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(popularMoviesStr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: InkWell(
                                            onTap: viewModel.navigateToViewAll,
                                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                              child: Text(viewAllStr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
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
                                        children: popularList
                                            .map((e) => MovieTile(
                                                  fn: () => viewModel
                                                      .navigateToDetails(e),
                                                  movie: e,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              );
                            }),

                        // Text('POPULAR SERIES',
                        //     style:
                        //     Theme.of(context).textTheme.headline1),
                        // const SizedBox(height: 16.0),
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
