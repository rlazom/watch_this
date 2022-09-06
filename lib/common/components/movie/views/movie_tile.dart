import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:watch_this/common/constants.dart';
import 'package:watch_this/common/enums.dart';
import 'package:watch_this/common/providers/user_provider.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
import 'package:watch_this/models/movie.dart';
import 'package:watch_this/models/movie_genre.dart';
import 'package:watch_this/models/watch_provider.dart';
import 'package:watch_this/repository/movies/movie_repository.dart';

class MovieTile extends StatelessWidget {
  final bool showToWatchIcon;
  final MovieRepository movieRepository;

  MovieTile({
    Key? key,
    this.showToWatchIcon = true,
  })  : movieRepository = MovieRepository(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Consumer<Movie>(builder: (context, movie, child) {
        // UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

        String title = movie.title;
        String subTitle = '';

        // if(movie.id == 755566) {
        //   print('movie.watchProvidersList: "${movie.watchProvidersList}"');
        //   print('movie.isNetflix: "${movie.inNetflix}"');
        // }

        List<String?> genres = movie.genres?.map((MovieGenre e) {
              if (e.name == null || e.name.toString().trim() == '') {
                e.name = userProvider.getGenreById(e.id).name;
              }
              return e.name;
            }).toList() ??
            [];

        String genreStr = genres.isEmpty ? '' : genres.first ?? '';
        String releaseDateStr = movie.releaseDate?.year.toString() ?? '';

        subTitle = genreStr;
        if (releaseDateStr.isNotEmpty) {
          subTitle += genreStr.isEmpty ? releaseDateStr : ' | $releaseDateStr';
        }

        final TextStyle textStyle = Theme.of(context).textTheme.headline6!;
        final Color iconColor = textStyle.color!;
        final double iconSize = textStyle.fontSize!;

        bool movieIsFavorite = userProvider.movieIsFavorite(movie.id);
        bool? movieIsLike = userProvider.getMovieRate(movie.id);
        bool movieIsToWatch = userProvider.movieIsToWatch(movie.id);

        Widget subTitleWdt = subTitle.isEmpty
            ? const SizedBox()
            : FittedBox(
                fit: BoxFit.scaleDown,
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
            if (movie.voteAverage <= 0) const Expanded(child: SizedBox()),
            if (movie.voteAverage > 0)
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
                if (showToWatchIcon && movieIsToWatch)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      Icons.remove_red_eye,
                      size: iconSize,
                      color: iconColor,
                    ),
                  ),
                if (movieIsLike != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      movieIsLike ? Icons.thumb_up : Icons.thumb_down,
                      size: iconSize,
                      color: iconColor,
                    ),
                  ),
                Icon(
                  movieIsFavorite ? Icons.favorite : Icons.favorite_border,
                  size: iconSize,
                  color: movieIsFavorite ? R.colors.accents.rose1 : iconColor,
                ),
              ],
            )
          ],
        );

        List<WatchProvider> topProviders = [];
        Widget? topBookmarkWdt;
        if (movie.inNetflix) {
          topProviders.add(movie.getProvider(TopProvider.netflix)!);
        }
        if (movie.inAmazon) {
          topProviders.add(movie.getProvider(TopProvider.amazon)!);
        }
        if (movie.inDisney) {
          topProviders.add(movie.getProvider(TopProvider.disney)!);
        }
        // if (movie.inGoogle) {
        //   topProviders.add(movie.getProvider(TopProvider.google)!);
        // }
        // if (movie.inApple) {
        //   topProviders.add(movie.getProvider(TopProvider.apple)!);
        // }

        if (topProviders.isNotEmpty) {
          for (WatchProvider provider in topProviders) {
            if (provider.logoPath != null && provider.logoPath!.trim() != '') {
              String imageUrl = R.urls.image(provider.logoPath!);
              provider.fLogo = movieRepository.getItemFile(
                  fileUrl: imageUrl, matchSizeWithOrigin: false);
            }
          }

          List<Widget> topProviderWdtList = List.from(topProviders
              .map((e) => Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipOval(
                        child: GridItemWdt(
                          tag: e.providerName,
                          fImage: e.fLogo,
                          fImageDefault: Icons.account_balance,
                          backgroundColor: Colors.transparent,
                          itemWidth: 20,
                          itemHeight: 20,
                          imagePadding: 0.0,
                        ),
                      ),
                    ),
                  ))
              .toList());
          topProviderWdtList.add(const SizedBox(
            height: 2.0,
          ));

          topBookmarkWdt = SimpleShadow(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 20.0,
                  decoration: const BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: topProviderWdtList,
                  ),
                ),
              ),
            ),
          );
        }

        Widget topMediaTypeWdt = SimpleShadow(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 16.0,
              height: 16.0,
              decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0, left: 2.0),
                  child: Icon(
                    Icons.movie_outlined,
                    color: Theme.of(context)
                        .primaryTextTheme
                        .headline2
                        ?.color,
                  ),
                ),
              ),
            ),
          ),
        );

        return GridItemWdt(
          // fn: fn,
          fn: movie.navigateToMovieDetails,
          fImage: movie.fPoster,
          title: title,
          subTitleWdt: subTitleWdt,
          extraWdt: extraWdt,
          topBookmarkWdt: topBookmarkWdt,
          topMediaTypeWdt: topMediaTypeWdt,
          backgroundColor: Colors.white10,
        );
      });
    });
  }
}
