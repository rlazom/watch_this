import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
import 'package:watch_this/models/movie.dart';
import '../../../widgets/loading_blur_wdt.dart';
import '../../../widgets/r_future_image.dart';
import '../view_model/movies_view_model.dart';

class MoviesPage extends StatelessWidget {
  static const String route = '/movies';
  final MoviesViewModel viewModel;

  const MoviesPage({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<MoviesViewModel>(
              builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService(context: context);
              return const LoadingBlurWdt();
            }

            Function translate = viewModel.translate;
            String myMoviesToWatchStr = translate('MY_MOVIES_TO_WATCH_TEXT');

            double blur = 3.0;
            Size size = MediaQuery.of(context).size;

            return Scrollbar(
              child: Stack(
                children: [
                  Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.topCenter,
                    children: [
                      RFutureImage(
                        fImage: null,
                        // defaultImgRoute: R.assets.images.defaultBackdropJpeg,
                        defaultImgWdt: Image.asset(R
                            .assets
                            .images
                            .defaultBackdropJpeg,
                          height: size.height,
                          width: size.width,
                        ),
                        // imgSize: const Size(0, 300),
                        imgSize: const Size(0, 500),
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
                              0.4,
                              0.7,
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
                          ValueListenableBuilder<List<Movie>?>(
                              valueListenable: viewModel.moviesNotifier,
                              builder: (context, movieList, _) {
                                if (movieList == null) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100.0,
                                        height: 100.0,
                                        child: Center(
                                          child:
                                          CircularProgressIndicator(
                                            key: key ?? const Key('MOVIES circular_loading'),
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

                                if (movieList.isEmpty) {
                                  return Container();
                                }

                                final double maxWidth = MediaQuery.of(context).size.width;
                                final double itemWidth = maxWidth / 3 - 16 - 16;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // if (movieCredits.isNotEmpty)
                                    //   Text('CREDITS',
                                    //       style: Theme.of(context)
                                    //           .textTheme
                                    //           .headline1),

                                    Material(
                                      color: Colors.transparent,
                                      child: Wrap(
                                          children: movieList
                                              .map(
                                                (e) {
                                                  String title = e.title;
                                                  if(e.releaseDate != null) {
                                                    title += ' (${e.releaseDate?.year})';
                                                  }

                                                  return GridItemWdt(
                                                    fn: () => viewModel
                                                        .navigateToMovieDetails(e),
                                                    // title: e.title,
                                                    title: title,
                                                    subTitle: e.character,
                                                    fImage: e.fPoster,
                                                    fImageDefault: Icons.movie_outlined,
                                                    itemWidth: itemWidth,
                                                  );
                                                },
                                              )
                                              .toList()),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
