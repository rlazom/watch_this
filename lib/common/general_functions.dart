import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory;
import 'dart:math';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'extensions.dart';
import 'enums.dart';

String getBaseUrl(video) {
  final parse = Uri.parse(video);
  final uri = parse.query != '' ? parse.replace(query: '') : parse;
  String url = uri.toString();
  if (url.endsWith('?')) url = url.replaceAll('?', '');
  return url;
}

Future<String> getLocalCacheFilesRoute(String url,
    {String extendedPath = '',
    bool isAbsolute = false,
    DirectoryType directoryType = DirectoryType.CACHE}) async {
  Directory temporaryDirectory =
      await _getDirectoryType(directoryType: directoryType);
  String temporaryDirectoryPath =
      isAbsolute ? temporaryDirectory.absolute.path : temporaryDirectory.path;
  url = removeDiacritics(Uri.decodeFull(url)).replaceAll(' ', '_');
  var baseUrl = getBaseUrl(url);
  String fileBaseName = path.basename(baseUrl);
  return path.join(temporaryDirectoryPath, extendedPath, fileBaseName);
}

Future<String> getDirectoryType({DirectoryType? directoryType}) async =>
    (await _getDirectoryType(directoryType: directoryType)).path;

Future<Directory> _getDirectoryType({DirectoryType? directoryType}) {
  switch (directoryType) {
    case DirectoryType.APP_DOCUMENTS:
      {
        return getApplicationDocumentsDirectory();
      }

    case DirectoryType.CACHE:
      {
        return getTemporaryDirectory();
      }

    default:
      {
        return getTemporaryDirectory();
      }
  }
}

Color getRandomColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

String decodeBase64(String str) {
  String output = base64Url.normalize(str);
  return utf8.decode(base64Url.decode(output));
}

Map<String, dynamic> parseJwt(String token, {bool getHeader = false}) {
  final parts = token.split('.');

  final header = decodeBase64(parts.first);
  final headerMap = json.decode(header);
  if (getHeader) {
    return headerMap;
  }

  if (parts.length != 3) {
    throw Exception('Invalid Token');
  }

  final payload = decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
//  var b = base64UrlEncode(utf8.encode(jsonEncode(headerMap)))+'.'+base64UrlEncode(utf8.encode(jsonEncode(payloadMap)));

  DateTime issuedAt = payloadMap['iat'].toString().fromTimeStamp;
  DateTime expiredAt = payloadMap['exp'].toString().fromTimeStamp;
  payloadMap['iat_date'] = issuedAt;
  payloadMap['exp_date'] = expiredAt;

  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('Invalid Payload');
  }

  return payloadMap;
}
