import 'dart:io' show File;
import 'package:flutter/material.dart';

import 'r_future_image.dart';

class GridItemWdt extends StatelessWidget {
  final VoidCallback? fn;
  final String tag;
  final Future<File?>? fImage;
  final IconData fImageDefault;
  final Size? imageSize;
  final double imagePadding;
  final String? title;
  final String? subTitle;
  final double itemWidth;
  final Color? backgroundColor;

  const GridItemWdt({
    Key? key,
    this.fn,
    this.tag = '',
    required this.fImage,
    this.fImageDefault = Icons.person,
    this.imageSize,
    this.imagePadding = 8.0,
    this.title,
    this.subTitle,
    this.itemWidth = 100,
    this.backgroundColor = Colors.white12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(imagePadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: fn,
        child: Container(
          width: itemWidth,
          decoration: BoxDecoration(
            color: backgroundColor,
            // borderRadius: BorderRadius.circular(8.0),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30.0),
              bottom: Radius.circular(8.0),
            ),
          ),
          // padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: imagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RFutureImage(
                tag: tag,
                fImage: fImage,
                imgAlignment: Alignment.topCenter,
                defaultImgWdt: Container(
                  width: 200,
                  height: 400,
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FittedBox(
                      child: Icon(
                        fImageDefault,
                        // color: Colors.white30,
                        color: Colors.black45,
                        size: 64.0,
                      ),
                    ),
                  ),
                ),
                // imgSize: 100.0,
                // imgSize: const Size(50, 100),
                imgSize: imageSize ?? Size(itemWidth / 2, itemWidth),
                boxFit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: imagePadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title!.replaceAll(' / ', '\n').replaceAll('/', '\n'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    if (subTitle != null)
                      Text(
                        subTitle!.replaceAll(' / ', '\n'),
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    if (title != null || subTitle != null)
                      SizedBox(height: imagePadding)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
