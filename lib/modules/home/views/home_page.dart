import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/modules/home/view_model/home_view_model.dart';

import '../../../common/widgets/loading_blur_wdt.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';
  final HomeViewModel viewModel;

  const HomePage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appTitle = viewModel.translate('APP_NAME');
    return Scaffold(
      appBar: AppBar(title: Text(appTitle)),
      body: ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService();
              return const LoadingBlurWdt();
            }
            return Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.black26,
                      child: Text('TRENDING'),
                    ),
                    Column(
                      children: viewModel.trendingList
                          .map((e) => Text(e.title))
                          .toList(),
                    ),
                    // Container(
                    //   color: Colors.black26,
                    //   child: Text('POPULAR'),
                    // ),
                    // Column(
                    //   children: viewModel.popularList
                    //       .map((e) => Text(e.title))
                    //       .toList(),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
