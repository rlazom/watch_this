import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
import 'package:watch_this/models/person.dart';

class PersonTile extends StatelessWidget {
  final bool showMediaTypeIcon;
  final VoidCallback? fn;
  final Person person;

  const PersonTile({Key? key, this.showMediaTypeIcon = false, this.fn, required this.person,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = person.name;
    String subTitle = person.job ?? '';

    List<String> splitName = List.from(title.split(' '));
    Widget titleWdt = SizedBox(
      width: double.infinity,
      child: Align(
        alignment: subTitle.isNotEmpty ? Alignment.centerLeft : Alignment.center,
        child: Wrap(
          children: splitName
              .map((e) => Text('$e ',
                  style: const TextStyle(fontWeight: FontWeight.bold)))
              .toList(),
        ),
      ),
    );

    Widget? subTitleWdt;
    if(subTitle.isNotEmpty) {
      subTitleWdt = SizedBox(
        width: double.infinity,
        child: Wrap(
          children: subTitle
              .split(' / ')
              .map((e) =>
              Text('$e ', style: Theme
                  .of(context)
                  .textTheme
                  .headline6))
              .toList(),
        ),
      );
    }

    Widget topMediaTypeWdt = const SizedBox.shrink();
    if(showMediaTypeIcon) {
      topMediaTypeWdt = SimpleShadow(
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
                  Icons.person_outline,
                  color: Theme
                      .of(context)
                      .primaryTextTheme
                      .headline2
                      ?.color,
                ),
              ),
            ),
          ),
        ),
      );
    }

    int imageFlex = 6;
    int textFlex = 4;
    int titleFlex = 1;
    int subTitleFlex = 3;
    if(subTitle.isEmpty) {
      imageFlex = 7;
      textFlex = 2;
    }

    return GridItemWdt(
      fn: fn,
      fImage: person.fProfile,
      titleWdt: titleWdt,
      subTitleWdt: subTitleWdt,
      topMediaTypeWdt: topMediaTypeWdt,
      backgroundColor: Colors.white10,
      itemHeight: 240.0,
      imageFlex: imageFlex,
      textFlex: textFlex,
      titleFlex: titleFlex,
      subTitleFlex: subTitleFlex,
    );
  }
}
