import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/components/movie/views/movie_tile.dart';
import 'package:watch_this/common/components/person/views/person_tile.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/common/enums.dart';
import 'package:watch_this/common/providers/user_provider.dart';
import 'package:watch_this/common/widgets/bottom_navigator_bar.dart';
import 'package:watch_this/models/cast.dart';
import 'package:watch_this/models/media.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/modules/filter/view_model/filter_view_model.dart';

import '../../../common/widgets/loading_blur_wdt.dart';

class FilterPage extends StatelessWidget {
  static const String route = '/filter';
  final FilterViewModel viewModel;

  const FilterPage({Key? key, required this.viewModel}) : super(key: key);

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
    Color backgroundColor = Theme.of(context).colorScheme.background;

    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(title: Text(appTitle)),
      bottomNavigationBar: BottomNavigatorBar(),
      body: ChangeNotifierProvider(
        // value: viewModel,
        create: (context) => FilterViewModel(),
        child: Consumer<FilterViewModel>(
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
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: () => viewModel.loadData(
                          context: context, forceReload: true),
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
            }

            // TextStyle textStyle = Theme.of(context).textTheme.headline2!;
            List<Widget> stackList = [];

            Function translate = viewModel.translate;
            String filterHintText = translate('FILTER_HINT_TEXT');
            String filtersText = translate('FILTERS_TEXT');

            stackList.add(
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: viewModel.textEditingController,
                        onSubmitted: (_) => viewModel.getMultiSearchData(),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: filterHintText,
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: viewModel.clearMultiSearch,
                                icon: const Icon(Icons.clear),
                              ),
                              IconButton(
                                onPressed: viewModel.getMultiSearchData,
                                icon: const Icon(Icons.search),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// SEARCH MEDIA(MOVIE,PERSON) LIST
                    Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                      return ValueListenableBuilder<List<Media>?>(
                          valueListenable: viewModel.searchListNotifier,
                          builder: (context, searchList, _) {
                            if (searchList == null) {
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
                                  Text('$filtersText...'),
                                ],
                              );
                            }

                            if (searchList.isEmpty) {
                              return Container();
                            }

                            return Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 0.45),
                                itemBuilder: (_, index) {
                                  Media media = searchList.elementAt(index);

                                  if(media.mediaType == MediaType.movie) {
                                    Movie movie = media as Movie;
                                    // print('index: $index/${movieList.length} - movie: [${movie.id}] "${movie.title}"');

                                    return ChangeNotifierProvider<Movie>.value(
                                      value: movie,
                                      child: MovieTile(showMediaTypeIcon: true),
                                    );
                                  }
                                  if(media.mediaType == MediaType.person) {
                                    Cast person = media as Cast;
                                    // print('index: $index/${movieList.length} - movie: [${movie.id}] "${movie.title}"');

                                    return PersonTile(
                                      showMediaTypeIcon: true,
                                      person: person,
                                      fn: () => viewModel.navigateToPersonDetails(person),
                                    );
                                  }
                                  return Container(
                                    color: Colors.blue,
                                    child: Text(media.title),
                                  );
                                },
                                itemCount: searchList.length,
                                // itemCount: (viewModel.isFullList || viewModel.isLastPage)
                                //     ? movieList.length
                                //     : movieList.length + 1,
                              ),
                            );

                            // return Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Material(
                            //       color: Colors.transparent,
                            //       child: SingleChildScrollView(
                            //         scrollDirection: Axis.horizontal,
                            //         child: Row(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: myMoviesToWatch
                            //               .map((e) => ChangeNotifierProvider<
                            //                       Movie>.value(
                            //                     value: e,
                            //                     child: MovieTile(
                            //                       showToWatchIcon: false,
                            //                     ),
                            //                   ))
                            //               .toList(),
                            //         ),
                            //       ),
                            //     ),
                            //     const SizedBox(height: 16.0),
                            //   ],
                            // );
                          });
                    }),
                  ],
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
