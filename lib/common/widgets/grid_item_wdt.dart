import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'r_future_image.dart';

class GridItemWdt extends StatelessWidget {
  final double itemWidth;
  final double itemHeight;
  final VoidCallback? fn;
  final String tag;
  final Future<File?>? fImage;
  final IconData fImageDefault;
  final Size? imageSize;
  final double imagePadding;
  final int imageFlex;
  final int textFlex;
  final int titleFlex;
  final int subTitleFlex;
  final String? title;
  final Widget? titleWdt;
  final String? subTitle;
  final Widget? subTitleWdt;
  final Widget? extraWdt;
  final Color? backgroundColor;

  const GridItemWdt({
    Key? key,
    this.itemWidth = 100,
    this.itemHeight = 220,
    this.fn,
    this.tag = '',
    required this.fImage,
    this.fImageDefault = Icons.person,
    this.imageSize,
    this.imagePadding = 8.0,
    this.imageFlex = 7,
    this.textFlex = 3,
    this.titleFlex = 2,
    this.subTitleFlex = 1,
    this.title,
    this.titleWdt,
    this.subTitle,
    this.subTitleWdt,
    this.extraWdt,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(imagePadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: fn,
        child: SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Column(
            children: [
              Expanded(
                flex: imageFlex,
                child: RFutureImage(
                  tag: tag,
                  fImage: fImage,
                  imgAlignment: Alignment.topCenter,
                  defaultImgWdt: Container(
                    width: 200,
                    height: 400,
                    color: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
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
                  imgSize: imageSize,
                  boxFit: BoxFit.cover,
                ),
              ),
              if (title != null ||
                  titleWdt != null ||
                  subTitleWdt != null ||
                  subTitle != null ||
                  extraWdt != null)
                Expanded(
                  flex: textFlex,
                  child: Container(
                    color: backgroundColor,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (titleWdt != null || (title != null && title.toString().trim() != ''))
                            Expanded(
                              flex: titleFlex,
                              child: Align(
                                alignment: Alignment.center,
                                child: titleWdt ??
                                    Text(
                                      title!
                                          .replaceAll(' / ', '\n')
                                          .replaceAll('/', '\n'),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                              ),
                            ),
                          if (subTitleWdt != null ||
                              (subTitle != null && subTitle!.trim() != ''))
                            Expanded(
                              flex: subTitleFlex,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: subTitleWdt ??
                                    Text(
                                      subTitle!.replaceAll(' / ', '\n'),
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                              ),
                            ),
                          if (extraWdt != null)
                            Expanded(
                              child: extraWdt!,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
