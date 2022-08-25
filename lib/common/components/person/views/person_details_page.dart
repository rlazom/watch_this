import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/person.dart';
import '../../../widgets/loading_blur_wdt.dart';
import '../../../widgets/r_future_image.dart';
import '../view_model/person_details_view_model.dart';

class PersonDetailsPage extends StatelessWidget {
  static const String route = '/person_details';
  final PersonDetailsViewModel viewModel;

  const PersonDetailsPage({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Person person = ModalRoute.of(context)!.settings.arguments as Person;

    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<PersonDetailsViewModel>(
              builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService(context: context);
              return const LoadingBlurWdt();
            }

            double blur = 3.0;

            return Scrollbar(
              child: Stack(
                children: [
                  Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.topCenter,
                    children: [
                      RFutureImage(
                        fImage: viewModel.person!.fProfile,
                        defaultImgWdt: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.person,
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
                          ValueListenableBuilder<List<Movie>>(
                              valueListenable: viewModel.personMoviesNotifier,
                              builder: (context, movieCredits, _) {
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
                                          children: movieCredits
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
