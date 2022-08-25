import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'r_image.dart';

class RFutureImage extends StatelessWidget {
  final String tag;
  final String? defaultImgRoute;
  final Widget? defaultImgWdt;
  final Future<File?>? fImage;
  final Size imgSize;
  final Alignment imgAlignment;
  final BoxFit? boxFit;
  final bool showLoading;
  final Function? fn;
  final VoidCallback? voidCallback;

  const RFutureImage({
    Key? key,
    this.tag = '',
    this.defaultImgRoute,
    this.defaultImgWdt,
    required this.fImage,
    this.imgSize = const Size(30, 30),
    this.imgAlignment = Alignment.center,
    this.boxFit,
    this.showLoading = true,
    this.fn,
    this.voidCallback,
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
          alignment: imgAlignment,
        );
    defaultWdt = Container(
      alignment: imgAlignment,
      child: SizedBox(
        width: imgSize.width == 0 ? double.infinity : imgSize.width,
        height: imgSize.height == 0 ? double.infinity : imgSize.height,
        child: FittedBox(
          child: defaultWdt,
        ),
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
            bool isSvg = p.extension(tFile.path).toLowerCase() == '.svg';
            String tagName = tFile.path.split('/').last.split('.').first;

            return InkWell(
              onTap: voidCallback ?? (fn == null ? null : () => fn!(tFile.path)),
              child: Hero(
                tag: '$tag''$tagName',
                child: RImage(
                  imageFile: tFile,
                  imgSize: imgSize,
                  boxFit: isSvg ? BoxFit.contain : boxFit,
                  imgAlignment: imgAlignment,
                ),
              ),
            );
          } else {
            return defaultWdt;
          }
        }

        if(!showLoading) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CircularProgressIndicator(
                key: const Key('circular_loading_flex_future_image'),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue.withOpacity(0.6))),
          ),
        );
      },
    );
  }
}
