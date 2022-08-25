import 'extensions.dart';
import 'package:flutter/material.dart' show Color;

/// URL ------------------------------------------------------------------------
class R {
  R._();
  static KUrl get urls => const KUrl._();
  static RkColors get colors => const RkColors._();
  static RkAssets get assets => const RkAssets._();
  static CacheDirectories get directories => const CacheDirectories._();
}
/// ----------------------------------------------------------------------------

/// URLs -----------------------------------------------------------------------
class KUrl {
  const KUrl._();
  static const String domain = 'https://api.themoviedb.org';
  // final String popularity = '$domain''/4/discover/movie';
  final String popularity = '$domain''/3/movie/popular';
  final String trending = '$domain''/3/trending/movie/week';
  String company(String companyId) => '$domain''/3/company/$companyId';
  String collection(int collectionId) => '$domain''/3/collection/$collectionId';
  KUrlMovie get movieModule => const KUrlMovie._();
  KUrlPerson get personModule => const KUrlPerson._();

  String image(String imageUrl) => 'https://image.tmdb.org/t/p/w200$imageUrl';
  String imageW500(String imageUrl) => 'https://image.tmdb.org/t/p/w500$imageUrl';
  String imageOriginal(String imageUrl) => 'https://image.tmdb.org/t/p/original$imageUrl';
}
class KUrlMovie {
  const KUrlMovie._();
  String details({required int movieId}) => '${KUrl.domain}''/3/movie/$movieId';
  String credits({required int movieId}) => '${KUrl.domain}''/3/movie/$movieId/credits';
  String keywords({required int movieId}) => '${KUrl.domain}''/3/movie/$movieId/keywords';
  String similar({required int movieId}) => '${KUrl.domain}''/3/movie/$movieId/similar';
  String recommendations({required int movieId}) => '${KUrl.domain}''/3/movie/$movieId/recommendations';
  String images({required int movieId}) => '${KUrl.domain}''/3/movie/$movieId/images';
}
class KUrlPerson {
  const KUrlPerson._();
  String person({required int personId}) => '${KUrl.domain}''/3/person/$personId';
  String movies({required int personId}) => '${KUrl.domain}''/3/person/$personId/movie_credits';
}
/// ----------------------------------------------------------------------------

/// Colors ---------------------------------------------------------------------
class RkColors {
  const RkColors._();
  RkColorPrimary get primaries => const RkColorPrimary._();
  RkColorAccent get accents => const RkColorAccent._();
  RkColorNeutral get neutrals => const RkColorNeutral._();
  RkColorSemantic get semantics => const RkColorSemantic._();

  Color get mapDarkBackgroundColor => '#242424'.hexToColor();
  Color get mapLightBackgroundColor => '#9ec5ef'.hexToColor();
}
class RkColorPrimary {
  const RkColorPrimary._();
  Color get red1 => '#F25050'.hexToColor();
  Color get red2 => '#CC4343'.hexToColor();
  Color get red3 => '#993232'.hexToColor();
  Color get red4 => '#802A2A'.hexToColor();
  Color get yellow1 => '#F2C70B'.hexToColor();
  Color get yellow2 => '#CCA809'.hexToColor();
  Color get yellow3 => '#997E07'.hexToColor();
  Color get yellow4 => '#665404'.hexToColor();
}
class RkColorAccent {
  const RkColorAccent._();
  Color get blue1 => '#1095F2'.hexToColor();
  Color get blue2 => '#0D7ECC'.hexToColor();
  Color get blue3 => '#0A5E99'.hexToColor();
  Color get blue4 => '#073F66'.hexToColor();
}
class RkColorNeutral {
  const RkColorNeutral._();
  Color get yellow1 => '#FFF1B4'.hexToColor();
  Color get yellow2 => '#FAE277'.hexToColor();
  Color get yellow3 => '#E6D173'.hexToColor();
  Color get yellow4 => '#E4BA00'.hexToColor();
}
class RkColorSemantic {
  const RkColorSemantic._();
  Color get green1 => '#8FF297'.hexToColor();
  Color get green2 => '#78CC7F'.hexToColor();
  Color get green3 => '#4B7F50'.hexToColor();
  Color get green4 => '#3C6640'.hexToColor();
  Color get red1 => '#F25050'.hexToColor();
  Color get red2 => '#CC4343'.hexToColor();
  Color get red3 => '#993232'.hexToColor();
  Color get red4 => '#662222'.hexToColor();
}
/// ----------------------------------------------------------------------------

/// Assets  --------------------------------------------------------------------
// class FlexAssets {
//   const FlexAssets._();
//   Map<AudioType, String> get audio => {
//     AudioType.WORK: 'beep1.mp3',
//     AudioType.REST: 'beep2.mp3',
//     AudioType.FINISH: 'beep4.mp3',
//     AudioType.COUNTDOWN_3: 'beep_alarm_3.mp3',
//     AudioType.COUNTDOWN_2: 'beep_alarm_2.mp3',
//     AudioType.COUNTDOWN_1: 'beep_alarm_1.mp3',
//   };
// }

class RkAssets {
  const RkAssets._();
  static const String assetsFolder = 'assets/';
  RkImages get images => const RkImages._();
}
class RkImages {
  const RkImages._();
  static const String assetsPngFolder = 'png/';
  static const String assetsJpegFolder = 'jpeg/';
  static const String assetsSvgFolder = 'svg/';

  String get makkuraLogoJpeg => '${RkAssets.assetsFolder}$assetsJpegFolder''makkura.jpg';

  /// ---- SPLASH
  String get splashJpeg => makkuraLogoJpeg;
}
/// ----------------------------------------------------------------------------

/// Cache Directories ----------------------------------------------------------
class CacheDirectories {
  const CacheDirectories._();
  String get dirAssetsPath => 'assets';
  String get dirDownloadPath => 'download';
}
/// ----------------------------------------------------------------------------