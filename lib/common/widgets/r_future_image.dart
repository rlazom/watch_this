import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'r_image.dart';

class RFutureImage extends StatelessWidget {
  final String? defaultImgRoute;
  final Widget? defaultImgWdt;
  final Future<File?>? fImage;
  final Size imgSize;
  final BoxFit? boxFit;

  const RFutureImage({
    Key? key,
    this.defaultImgRoute,
    this.defaultImgWdt,
    required this.fImage,
    this.imgSize = const Size(30, 30),
    this.boxFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((defaultImgRoute == null ||
            (defaultImgRoute != null && defaultImgRoute!.trim() == '')) &&
        defaultImgWdt == null) {
      return Container();
    }

    Widget defaultWdt = defaultImgWdt ??
        Image(
          image: AssetImage(defaultImgRoute!),
          height: imgSize.height,
          width: imgSize.width,
        );
    defaultWdt = SizedBox(
      height: imgSize.height,
      width: imgSize.width,
      child: FittedBox(
        child: defaultWdt,
      ),
    );

    if (fImage == null) {
      return defaultWdt;
    }

    return FutureBuilder<File?>(
      future: fImage,
      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final File tFile = snapshot.data!;
            bool isSvg = p.extension(tFile.path).toLowerCase() != '.svg';

            return RImage(
              imageFile: tFile,
              imgSize: imgSize,
              boxFit: isSvg ? BoxFit.contain : boxFit,
            );
          } else {
            return defaultWdt;
          }
        }
        return SizedBox(
          width: imgSize.width,
          height: imgSize.height,
          child: CircularProgressIndicator(
              key: const Key('circular_loading_flex_future_image'),
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue.withOpacity(0.6))),
        );
      },
    );
  }
}
