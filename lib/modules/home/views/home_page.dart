import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_this/models/movie.dart';
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
            if(viewModel.failed) {
              return Center(
                child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(viewModel.error?.toString() ?? ''),
                  ),
                ),
              );
            }
            if (viewModel.failed) {
              return Center(
                child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(viewModel.error?.toString() ?? 'ERROR'),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: viewModel.trendingList.length,
              itemBuilder: (BuildContext context, int index) {
                Movie movie = viewModel.trendingList.elementAt(index);
                return ListTile(
                  title: Text(movie.title),
                  onTap: () => viewModel.navigateToDetails(movie),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
