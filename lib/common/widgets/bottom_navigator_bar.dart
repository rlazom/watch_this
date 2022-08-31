import 'package:flutter/material.dart';
import 'package:watch_this/l10n/app_localizations.dart';
import 'package:watch_this/modules/home/views/home_page.dart';
import 'package:watch_this/services/navigation_service.dart';

import '../constants.dart';

class BottomNavigatorBar extends StatelessWidget {
  static final NavigationService navigator = NavigationService();
  final selectedItemColor = R.colors.primary;
  final unselectedItemColor = Colors.white70;

  // final List<String> _kTabPages = <String>[
  //   // MyFavoritesRoutes.root,
  //   HomePage.route,
  //   // CustomTimerRoutes.root,
  // ];
  final List<Map> tabPagesMap = [
    {'icon':const Icon(Icons.home_outlined), 'label':_translate('HOME_TEXT'),'route': HomePage.route},
    {'icon':const Icon(Icons.bookmark_outline), 'label':_translate('MY_LIST_TEXT'),'route': HomePage.route},
  ];

  BottomNavigatorBar({Key? key}) : super(key: key);

  List get kTabPages => tabPagesMap.map((e) => e['route']).toList();

  List<BottomNavigationBarItem> _getBottomNavBarItems(int idx) {
    List<BottomNavigationBarItem> list = [];
    for(Map page in tabPagesMap) {
      list.add(
          BottomNavigationBarItem(
            icon: page['icon'],
            label: page['label'],
          )
      );
    }
    // list.addAll([
    //   BottomNavigationBarItem(
    //     icon: SvgPicture.asset(
    //       'assets/svg/my_favorites.svg',
    //       color: idx == 0 ? selectedItemColor : unselectedItemColor,
    //       width: 24,
    //     ),
    //     label: _translate('MY_FAVORITES'),
    //   ),
    //   BottomNavigationBarItem(
    //     icon: const Icon(
    //       Icons.home_outlined,
    //       // color: Colors.white70,
    //     ),
    //     label: _translate('HOME_TEXT'),
    //   ),
    //   BottomNavigationBarItem(
    //     icon: const Icon(
    //       Icons.timer,
    //     ),
    //     label: _translate('TIMER_TEXT'),
    //   ),
    // ]);
    return list;
  }

  static _translate(String key) =>
      AppLocalizations.of(navigator.context)!.translate(key);

  _getIndex(String? route) {
    int idx = 1;
    // final List tabPages = kTabPages.map((e) => e['route']).toList();

    for (var page in kTabPages) {
      if (route!.contains(page) && route.indexOf(page) == 0) {
        idx = kTabPages.indexOf(page);
      }
    }
    return idx;
  }

  _navigateTo(int index) {
    navigator.pushNamedAndRemoveUntilHome(kTabPages.elementAt(index));
  }

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)!.settings.name;
    int currentIndex = _getIndex(currentRoute);
    final kBottomNavBarItems = _getBottomNavBarItems(currentIndex);
    // assert(kTabPages.length == kBottomNavBarItems.length);

    final bottomNavBar = BottomNavigationBar(
      items: kBottomNavBarItems,
      selectedItemColor: currentIndex == 1 ? unselectedItemColor : null,
      unselectedItemColor: unselectedItemColor,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _navigateTo,
    );

    return bottomNavBar;
  }
}
