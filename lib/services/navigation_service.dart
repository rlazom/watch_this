import 'package:flutter/material.dart';
import '../common/routes.dart';

class NavigationService {
  static final NavigationService _navigationService = NavigationService._();

  factory NavigationService() => _navigationService;

  NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get state => navigatorKey.currentState;

  BuildContext get context => state!.context;

  /// ROUTES
  Future<T?> to<T>({Widget? destinationWidget}) {
    return state!.push<T>(MaterialPageRoute(builder: (_) => destinationWidget!));
  }

  Future<T?> pushNamedAndRemoveUntilHome<T>(String routeTo) async {
    return state!.pushNamedAndRemoveUntil(
        routeTo,
        (Route<dynamic> route) => routeTo == home
            ? false
            : route.settings.name == home);
  }

  pop({BuildContext? context, var arguments}) {
    Navigator.pop(context ?? this.context, arguments);
  }

  Future<T?> toRoute<T>(String routeTo,
      {bool pushAndReplace = false, arguments}) {
    if (pushAndReplace) {
      return state!.pushReplacementNamed(routeTo, arguments: arguments);
    }
    return state!.pushNamed(routeTo, arguments: arguments);
  }
}
