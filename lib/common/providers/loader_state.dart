import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../l10n/app_localizations.dart';
import '../../services/navigation_service.dart';

enum LoaderState {
  normal,
  loading,
  failed,
  success,
}

abstract class LoaderViewModel extends ChangeNotifier {
  static final NavigationService _navigator = NavigationService();
  final Function translate;

  LoaderState _state = LoaderState.normal;
  Exception? error;
  bool _disposed = false;

  NavigationService get navigator => _navigator;

  LoaderViewModel()
      : translate = AppLocalizations.of(_navigator.context)!.translate;

  bool get disposed => _disposed;

  bool get loading => _state == LoaderState.loading;

  bool get notLoading => !loading;

  bool get success => _state == LoaderState.success;

  bool get failed => _state == LoaderState.failed;

  bool get normal => _state == LoaderState.normal;

  LoaderState get state => _state;

  @protected
  void updateState(LoaderState state, {bool emitEvent = true}) {
    if (_state == state) {
      return;
    }
    _state = state;
    if (!disposed && emitEvent) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> load(Future<void> Function() loader) async {
    try {
      markAsLoading();
      await loader();
      markAsSuccess();
    } on Exception catch (error) {
      markAsFailed(error: error);
      rethrow;
    }
  }

  void markAsLoading() {
    updateState(LoaderState.loading);
  }

  void markAsSuccess({dynamic arguments}) {
    updateState(LoaderState.success);
  }

  void markAsFailed({Exception? error}) {
    this.error = error;
    updateState(LoaderState.failed);
  }

  void markAsNormal({bool emitEvent = true}) {
    updateState(LoaderState.normal, emitEvent: emitEvent);
  }

  void scheduleLoadService({BuildContext? context}) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      loadData(context: context);
    });
  }

  void showSnackBarMsg(
      {required BuildContext context,
      required String msg,
      Color? backgroundColor}) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: const Key('scaffoldKeySnackBar'),
        content: Text(
          msg.trim(),
          style: TextStyle(color: Theme.of(context).textTheme.headline4!.color),
        ),
        duration: const Duration(milliseconds: 3000),
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      ));
    });
  }

  preCacheImages(List<String> imgList, BuildContext context) async {
    List<Future> list = [];
    for (String imgRoute in imgList) {
      list.add(
        _preCacheImage(imgRoute, context),
      );
    }

    await Future.wait(list);
  }

  _preCacheImage(String imageRoute, BuildContext context) async {
    await precacheImage(Image.asset(imageRoute).image, context);
  }

  void loadData({BuildContext? context});
}
