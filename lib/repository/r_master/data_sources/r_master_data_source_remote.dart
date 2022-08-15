import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../../services/http_service.dart';
import '../../../services/shared_preferences_service.dart';

class RMasterDataSourceRemote extends HttpService {
  final SharedPreferencesService shared = SharedPreferencesService();

  RMasterDataSourceRemote() : super();

  Future<File?> getItemFile(
      {required String imageUrl, required String fileLocalRouteStr, bool matchSizeWithOrigin = true}) async {
    File localFile = File(fileLocalRouteStr);
    // print('FlexMasterDataSourceRemote - getItemFile() - imageUrl: $imageUrl, fileLocalRouteStr: $fileLocalRouteStr');

    var dio = new Dio();
    try {
      await dio.download(imageUrl, fileLocalRouteStr);
    } catch (e) {
      print('FlexMasterDataSourceRemote - getItemFile() - CATCH ERROR: "${e.toString()}"');
      return null;
    }
    return localFile;
  }
}
