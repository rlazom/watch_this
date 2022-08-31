import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/common/providers/user_provider.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/movie_genre.dart';

class MovieTile extends StatelessWidget {
  final VoidCallback? fn;
  final Movie movie;

  const MovieTile({Key? key, this.fn, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String title = movie.title;
    String subTitle = '';

    List<String?> genres = movie.genres?.map((MovieGenre e) {
          if (e.name == null || e.name.toString().trim() == '') {
            e.name = userProvider.getGenreById(e.id).name;
          }
          return e.name;
        }).toList() ??
        [];

    subTitle = genres.first!;
    if (movie.releaseDate != null) {
      subTitle += ' | ${movie.releaseDate!.year}';
    }

    final TextStyle textStyle = Theme.of(context).textTheme.headline6!;
    // final TextStyle textStyle = Theme.of(context).textTheme.bodyText2!;
    final Color iconColor = textStyle.color!;
    final double iconSize = textStyle.fontSize!;

    bool movieIsFavorite = userProvider.movieIsFavorite(movie.id);
    bool? movieIsLike = userProvider.getMovieRate(movie.id);
    Widget subTitleWdt = FittedBox(
      child: Text(
        subTitle.replaceAll(' / ', '\nº'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      ),
    );
    Widget extraWdt = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, size: iconSize, color: iconColor),
            const SizedBox(width: 4.0),
            Text(movie.voteAverage.toStringAsFixed(1), style: textStyle),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (movieIsLike != null)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(movieIsLike ? Icons.thumb_up : Icons.thumb_down,
                    size: iconSize, color: iconColor),
              ),
            Icon(movieIsFavorite ? Icons.favorite : Icons.favorite_border,
                size: iconSize,
                color: movieIsFavorite ? R.colors.accents.rose1 : iconColor),
          ],
        )
      ],
    );

    return GridItemWdt(
      fn: fn,
      fImage: movie.fPoster,
      title: title,
      subTitleWdt: subTitleWdt,
      extraWdt: extraWdt,
      backgroundColor: Colors.white10,
    );
  }
}
