import 'dart:ui';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/models/person.dart';
import '../../../widgets/loading_blur_wdt.dart';
import '../../../widgets/r_future_image.dart';
import '../view_model/movie_details_view_model.dart';
import 'stars_rating.dart';

class MovieDetailsPage extends StatelessWidget {
  static const String route = '/movie_details';
  final MovieDetailsViewModel viewModel;

  const MovieDetailsPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAILS'),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<MovieDetailsViewModel>(
              builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService(context: context);
              return const LoadingBlurWdt();
            }

            String locale = Localizations.localeOf(context).toString();
            locale = locale.split('_').first;

            // print('viewModel.movie!.backdropPath: "${viewModel.movie!.backdropPath}"');
            double blur = 3.0;

            String? tagline;
            if (viewModel.movie!.tagline != null &&
                viewModel.movie!.tagline!.trim() != '') {
              tagline = viewModel.movie!.tagline!.trim();
            }

            String movieDurationStr = printDuration(
              viewModel.movie!.runtime!,
              abbreviated: true,
              locale: DurationLocale.fromLanguageCode(locale)!,
            );

            List<String?> genres =
                viewModel.movie!.genres?.map((e) => e.name).toList() ?? [];
            String genresStr = genres.join(' / ');

            return Stack(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    RFutureImage(
                      fImage: viewModel.movie!.fBackdrop,
                      defaultImgWdt: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.movie_outlined,
                          color: Colors.white30,
                        ),
                      ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RFutureImage(
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
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                if (tagline != null)
                                  Text(
                                    '"$tagline"',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                Text(
                                  '(${viewModel.movie!.releaseDate.year}) | ${viewModel.movie!.productionCountries?.first.iso3166_1}',
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        child: StarsRating(
                                            rating:
                                                viewModel.movie!.voteAverage),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'imbd: ${viewModel.movie!.voteAverage.toStringAsFixed(2)}',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(movieDurationStr),
                                Text(genresStr),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text('STORYLINE',
                          style: Theme.of(context).textTheme.headline1),
                      const SizedBox(height: 8.0),
                      Text(viewModel.movie!.overview),
                      const SizedBox(height: 16.0),
                      // Text('CREDITS', style: Theme.of(context).textTheme.headline1),
                      ValueListenableBuilder<List<Person>>(
                          valueListenable: viewModel.movieCreditsNotifier,
                          builder: (context, movieCredits, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (movieCredits.isNotEmpty)
                                  Text('CREDITS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: movieCredits
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RFutureImage(
                                                        fImage: e.fProfile,
                                                        defaultImgWdt:
                                                            const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons.person,
                                                            color:
                                                                Colors.white30,
                                                            size: 64.0,
                                                          ),
                                                        ),
                                                        // imgSize: 100.0,
                                                        imgSize: const Size(50, 100),
                                                        boxFit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        e.name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(e.job.replaceAll(
                                                          ' / ', '\n')),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                          .toList()),
                                ),
                              ],
                            );
                            // return ListView.builder(
                            //   scrollDirection: Axis.horizontal,
                            //   itemCount: movieCredits.length,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     Person person = movieCredits.elementAt(index);
                            //     return Padding(
                            //       padding: const EdgeInsets.all(2.0),
                            //       child: Container(
                            //         color: Colors.red,
                            //         // key: PageStorageKey("key_data_$index"),
                            //         child: Text(person.name),
                            //       ),
                            //     );
                            //   },
                            // );
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
