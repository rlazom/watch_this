import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

class RImage extends StatelessWidget {
  final File imageFile;
  final Size imgSize;
  final BoxFit? boxFit;

  const RImage({
    Key? key,
    required this.imageFile,
    this.imgSize = const Size(30, 30),
    this.boxFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxFit boxFit = this.boxFit ?? BoxFit.fitWidth;
    if (p.extension(imageFile.path).toLowerCase() != '.svg') {
      return Image.file(
        imageFile,
        width: imgSize.width == 0 ? double.infinity : imgSize.width,
        height: imgSize.height == 0 ? double.infinity : imgSize.height,
        fit: boxFit,
      );
    } else {
      return SvgPicture.file(
        imageFile,
        fit: boxFit,
        width: imgSize.width + 8,
        height: imgSize.height + 8,
      );
    }
  }
}