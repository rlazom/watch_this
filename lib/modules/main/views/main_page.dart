import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/constants.dart';
import '../view_model/main_view_model.dart';
export '../view_model/main_view_model.dart';

class MainPage extends StatelessWidget {
  static const String route = '/';
  final MainViewModel viewModel;

  const MainPage({Key? key, required this.viewModel}) : super(key: key);

  Widget _buildSplash() {
    List<Widget> stackList = [];
    BuildContext context = viewModel.navigator.context;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    stackList.add(
      SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          R.assets.images.splashJpeg,
          fit: BoxFit.fitHeight,
        ),
      ),
    );

    stackList.add(
      Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: isLandscape ? 40.0 : 100.0, bottom: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: isLandscape ? 0 : 120,
                ),
                Hero(
                  tag: 'app_logo',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120.0,
                        height: 120.0,
                        child: CircularProgressIndicator(
                          key: const Key('circular_loading'),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Stack(
      key: const Key('main_page_stack_key'),
      children: stackList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<MainViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService(context: context);
              return _buildSplash();
            }
            return _buildSplash();
          },
        ),
      ),
    );
  }
}
