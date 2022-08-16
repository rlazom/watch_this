import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../widgets/loading_blur_wdt.dart';
import '../../../widgets/r_future_image.dart';
import '../view_model/movie_details_view_model.dart';

class MovieDetailsPage extends StatelessWidget {
  static const String route = '/movie_details';
  final MovieDetailsViewModel viewModel;

  const MovieDetailsPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAILS'),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<MovieDetailsViewModel>(
              builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService(context: context);
              return const LoadingBlurWdt();
            }

            return Stack(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 300,
                      width: maxWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            R.urls.image(viewModel.movie!.backdropPath),
                          ),
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: const SizedBox(),
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
                        imgSize: Size(100, 100),
                        boxFit: BoxFit.cover,
                      ),
                      Text(
                        viewModel.movie!.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(viewModel.movie!.overview),
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
