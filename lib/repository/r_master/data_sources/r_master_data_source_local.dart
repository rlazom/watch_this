import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io' show File, SocketException;

import '../../../services/shared_preferences_service.dart';

class RMasterDataSourceLocal {
  final SharedPreferencesService shared = SharedPreferencesService();

  RMasterDataSourceLocal();

  Future<int> fetchFileTotalSize(fileUrl) async {
    int fileSize = -1;
    Response response;
    Response defaultResponse = Response(requestOptions: RequestOptions(path: '', headers: {'Content-Range': '0/-1'}));
    try {
      response = await Dio().get(
          fileUrl, options: Options(headers: {'Range': 'bytes=0-0'}));
    } on SocketException catch (_) {
      response = defaultResponse;
    } on TimeoutException catch (_) {
      response = defaultResponse;
    } catch (error) {
      response = defaultResponse;
    }

    String? contentRange = response.headers.value('Content-Range');
    if(contentRange != null) {
      contentRange = contentRange.split('/').last;
      fileSize = int.parse(contentRange);
    }
    return fileSize;
  }

  bool _checkFileMatched(String localFilePath) {
    List<String> list = shared.getCheckedMediaData();
    print('FlexMasterDataSourceLocal - _checkFileMatched(localFilePath: "$localFilePath") - fileMatched - "${list.contains(localFilePath)}"');
    return list.contains(localFilePath);
  }

  Future<File?> getItemFile(
      {required String imageUrl, required String fileLocalRouteStr, bool matchSizeWithOrigin = true}) async {
    File localFile = File(fileLocalRouteStr);

    // print('FlexMasterDataSourceLocal - getItemFile() - imageUrl: "${imageUrl.split('/').last.split('?').first}" - localFile: "${localFile.path}", localFile.existsSync(): "${localFile.existsSync()}"');
    if (localFile.existsSync()) {
      int fileLocalSize = localFile.lengthSync();
      bool _fileChecked = matchSizeWithOrigin ? _checkFileMatched(localFile.path) : true;
      int fileOriginSize = (!matchSizeWithOrigin || _fileChecked) ? fileLocalSize : await fetchFileTotalSize(imageUrl);

      // print('FlexMasterDataSourceLocal - getItemFile() - matchSizeWithOrigin: "$matchSizeWithOrigin", fileOriginSize: "$fileOriginSize", fileLocalSize: $fileLocalSize');
      // print('FlexMasterDataSourceLocal - getItemFile() - imageUrl: "${imageUrl.split('/').last.split('?').first}" - CACHED: "${fileLocalSize == fileOriginSize}" - fileOriginSize: "$fileOriginSize", fileLocalSize: "$fileLocalSize"');
      fileOriginSize = fileOriginSize == -1 ? fileLocalSize : fileOriginSize;

      if(fileLocalSize > 0 && fileLocalSize == fileOriginSize) {
        if(matchSizeWithOrigin && !_fileChecked) {
          shared.addCheckedMediaData(localFile.path);
        }
        return localFile;
      }
    }
    return null;
  }
}
