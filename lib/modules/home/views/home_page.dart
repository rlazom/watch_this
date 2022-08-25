import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
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
    String appTitle = viewModel.translate('APP_NAME');

    PageController controller = PageController(
      viewportFraction: 1,
      keepPage: true,
    );

    Color backgroundColor = Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text(appTitle)),
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
                    const Icon(
                      Icons.error_outline,
                      size: 128,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
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

            List<Widget> stackList = [];

            stackList.add(
              RefreshIndicator(
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
                                            const Text('TRENDING MOVIES...'),
                                          ],
                                        );
                                      }

                                      if (trendingList.isEmpty) {
                                        return Image.asset(
                                          'assets/jpeg/default_backdrop.jpg',
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
                                                    fImage: movie.fBackdrop,
                                                    defaultImgWdt:
                                                        const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons.movie_outlined,
                                                        color: Colors.white30,
                                                      ),
                                                    ),
                                                    imgSize:
                                                        const Size(500, 200),
                                                    imgAlignment:
                                                        Alignment.topCenter,
                                                    boxFit: BoxFit.cover,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.black
                                                              .withOpacity(0.6),
                                                          Colors.black45,
                                                          Colors.transparent,
                                                          Colors.transparent,
                                                          backgroundColor,
                                                        ],
                                                        stops: const [
                                                          0.02,
                                                          0.09,
                                                          0.20,
                                                          0.80,
                                                          0.95,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0,
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Text(
                                                        movie.title,
                                                        // '${movie.title} ${movie.title} ${movie.title}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 16.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.trending_up,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                ?.color,
                                            size: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                ?.fontSize),
                                        const SizedBox(width: 8.0),
                                        const Text('TOP TRENDING MOVIES'),
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
                                valueListenable: viewModel.trendingListNotifier,
                                builder: (context, trendingList, _) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: SmoothPageIndicator(
                                      controller: controller, // PageController
                                      count: trendingList?.length ?? 0,
                                      effect: const ScrollingDotsEffect(
                                        activeDotColor: Colors.blue,
                                        maxVisibleDots: 9,
                                        activeDotScale: 1.5,
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

                      /// MY MOVIE LIST
                      ValueListenableBuilder<List<Movie>?>(
                          valueListenable: viewModel.myMoviesListNotifier,
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
                                  const Text('MY MOVIES...'),
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
                                Text('MY MOVIES',
                                    style:
                                        Theme.of(context).textTheme.headline1),
                                Material(
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: popularList
                                          .map((e) => GridItemWdt(
                                                fn: () => viewModel
                                                    .navigateToDetails(e),
                                                fImageDefault: Icons.movie_outlined,
                                                title: e.title,
                                                fImage: e.fPoster,
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
                                  const Text('POPULAR MOVIES...'),
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
                                Text('POPULAR MOVIES',
                                    style:
                                    Theme.of(context).textTheme.headline1),
                                Material(
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: popularList
                                          .map((e) => GridItemWdt(
                                        fn: () => viewModel
                                            .navigateToDetails(e),
                                        fImageDefault: Icons.movie_outlined,
                                        title: e.title,
                                        fImage: e.fPoster,
                                      ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            );
                          }),

                      Text('POPULAR SERIES',
                          style:
                          Theme.of(context).textTheme.headline1),
                      const SizedBox(height: 16.0),
                    ],
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
