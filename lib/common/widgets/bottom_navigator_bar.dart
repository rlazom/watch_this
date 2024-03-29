import 'package:flutter/material.dart';
import 'package:watch_this/l10n/app_localizations.dart';
import 'package:watch_this/services/navigation_service.dart';

import '../constants.dart';
import '../routes.dart';

class BottomNavigatorBar extends StatelessWidget {
  static final NavigationService navigator = NavigationService();
  final selectedItemColor = R.colors.primary;
  final unselectedItemColor = Colors.white70;
  final disabledItemColor = Colors.white24;

  // final List<String> _kTabPages = <String>[
  //   // MyFavoritesRoutes.root,
  //   HomePage.route,
  //   // CustomTimerRoutes.root,
  // ];
  final List<Map> tabPagesMap = [
    {'icon':const Icon(Icons.home_outlined), 'label':_translate('HOME_TEXT'), 'route': HomePage.route},
    {'icon':const Icon(Icons.filter_list), 'label':_translate('FILTERS_TEXT'), 'route': FilterPage.route},
    {'icon':const Icon(Icons.bookmark_outline), 'label':_translate('MY_LIST_TEXT'), 'route': HomePage.route},
  ];

  BottomNavigatorBar({Key? key}) : super(key: key);

  List get kTabPages => tabPagesMap.map((e) => e['route']).toList();

  List<BottomNavigationBarItem> _getBottomNavBarItems(int idx) {
    List<BottomNavigationBarItem> list = [];
    // int i = 0;
    for(Map page in tabPagesMap) {
      // String? route = page['route'];
      list.add(
          BottomNavigationBarItem(
            icon: page['icon'],
            // icon: Icon((page['icon'] as Icon).icon, color: route == null || route.isEmpty ? disabledItemColor : i == idx ? selectedItemColor : unselectedItemColor,) ,
            label: page['label'],
          )
      );
      // i++;
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
    int idx = -1;
    // print('BottomNavigatorBar - _getIndex(route: "$route")');
    // print('BottomNavigatorBar - _getIndex() - kTabPages: "$kTabPages"');

    for (var page in kTabPages) {
      if (route!.contains(page) && route.indexOf(page) == 0) {
        idx = kTabPages.indexOf(page);
      }
    }
    return idx;
  }

  _navigateTo(int index) {
    String? route = kTabPages.elementAt(index);
    if(route != null) {
      navigator.pushNamedAndRemoveUntilHome(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)!.settings.name;
    int currentIndex = _getIndex(currentRoute);
    final kBottomNavBarItems = _getBottomNavBarItems(currentIndex);
    // assert(kTabPages.length == kBottomNavBarItems.length);

    final bottomNavBar = BottomNavigationBar(
      items: kBottomNavBarItems,
      selectedItemColor: currentIndex == -1 ? unselectedItemColor : null,
      unselectedItemColor: unselectedItemColor,
      currentIndex: currentIndex == -1 ? 0 : currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _navigateTo,
      showUnselectedLabels: false,
    );

    return bottomNavBar;
  }
}
