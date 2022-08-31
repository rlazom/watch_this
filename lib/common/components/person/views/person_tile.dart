import 'package:flutter/material.dart';
import 'package:watch_this/common/widgets/grid_item_wdt.dart';
import 'package:watch_this/models/person.dart';

class PersonTile extends StatelessWidget {
  final VoidCallback? fn;
  final Person person;

  const PersonTile({Key? key, this.fn, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = person.name;
    String subTitle = person.job;

    List<String> splitName = List.from(title.split(' '));
    Widget titleWdt = SizedBox(
      width: double.infinity,
      child: Wrap(
        children: splitName
            .map((e) => Text('$e ',
                style: const TextStyle(fontWeight: FontWeight.bold)))
            .toList(),
      ),
    );

    Widget subTitleWdt = SizedBox(
      width: double.infinity,
      child: Wrap(
        children: subTitle
            .split(' / ')
            .map((e) =>
                Text('$e ', style: Theme.of(context).textTheme.headline6))
            .toList(),
      ),
    );

    return GridItemWdt(
      fn: fn,
      fImage: person.fProfile,
      titleWdt: titleWdt,
      subTitleWdt: subTitleWdt,
      backgroundColor: Colors.white10,
      itemHeight: 240.0,
      imageFlex: 6,
      textFlex: 4,
      titleFlex: 1,
      subTitleFlex: 3,
    );
  }
}
