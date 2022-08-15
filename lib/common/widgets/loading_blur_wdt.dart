import 'package:flutter/material.dart';
import 'dart:ui';

class LoadingBlurWdt extends StatelessWidget {
  final bool withBackgroundBlur;

  const LoadingBlurWdt({
    Key? key, this.withBackgroundBlur = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget loadingWdt = Center(
      child: SizedBox(
        width: 100.0,
        height: 100.0,
        child: CircularProgressIndicator(
          key: key ?? const Key('circular_loading'),
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.blue.withOpacity(0.6),
          ),
        ),
      ),
    );

    if(!withBackgroundBlur) {
      return loadingWdt;
    }

    return Stack(
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: const BoxDecoration(color: Colors.black54),
            ),
          ),
        ),
        loadingWdt,
      ],
    );
  }
}
