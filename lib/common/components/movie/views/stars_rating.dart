import 'package:flutter/material.dart';

class StarsRating extends StatelessWidget {
  final double rating;

  const StarsRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    const Color color = Colors.amberAccent;
    Widget fullStar = const Icon(Icons.star, color: color);
    Widget halfStar = const Icon(Icons.star_half, color: color);
    Widget emptyStar = const Icon(Icons.star_border, color: color);

    // print('this.rating: "${this.rating}"');

    // double rating = this.rating*5/10;
    double rating = this.rating*5/10;

    // print('rating: "$rating"');
    // print('rating.ceil(): "${rating.ceil()}"');
    // print('rating.truncate(): "${rating.truncate()}"');
    for (int i = 1; i <= 5; i++) {
      Widget star;

      // print('IF i[$i] <= rating[$rating] => ${i <= rating}');
      if (i <= rating) {
        star = fullStar;
        // print('i: $i - "fullstar"');
      } else {
        // print('IF [-] => ${i == rating.truncate() && rating.ceil() > rating.truncate()}');
        if(i == rating.ceil()) {
          star = halfStar;
          // print('i: $i - "halfStar"');
        } else {
          star = emptyStar;
          // print('i: $i - "emptyStar"');
        }
      }
      list.add(Padding(
        padding: EdgeInsets.only(right: i==5 ? 0.0 : 6.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(7.0),
            ),
          ),
          padding: const EdgeInsets.all(4.0),
          child: star,
        ),
      ));
    }

    return Row(
      children: list,
    );
  }
}
