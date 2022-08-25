import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:watch_this/repository/movies/movie_repository.dart';

class FlatImage extends StatelessWidget {
  final String tag;
  final String imageRoute;
  final String imageUrl;
  final MovieRepository movieRepository;

  FlatImage(
      {Key? key,
      required this.tag,
      required this.imageRoute,
      required this.imageUrl})
      : movieRepository = MovieRepository(extendedPath: 'movies_big'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieImageNotifier = ValueNotifier<File?>(null);

    movieRepository.getItemFile(fileUrl: imageUrl).then((value) {
      movieImageNotifier.value = value;
    });

    final File imageFile = File(imageRoute);
    Widget imgWdt = Image.file(
      imageFile,
      fit: BoxFit.contain,
    );
    const double blur = 10.0;

    return SafeArea(
      child: Scaffold(
        body: InkWell(
          onTap: () => Navigator.pop(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// BACKDROP IMAGE
              Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),

              /// BLUR
              ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black54),
                  ),
                ),
              ),

              /// IMAGE (w200)
              Hero(
                tag: tag,
                // tag: 'expandImage',
                child: imgWdt,
              ),

              /// IMAGE (ORIGINAL)
              ValueListenableBuilder<File?>(
                valueListenable: movieImageNotifier,
                builder: (context, image, _) {
                  if (image == null) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Image.file(image, fit: BoxFit.contain);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
