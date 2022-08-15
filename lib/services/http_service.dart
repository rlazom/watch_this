import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watch_this/common/extensions.dart';

import '../common/keys.dart';
import 'navigation_service.dart';

class HttpService {
  final http.Client client = http.Client();
  Map<String, String> headers = {};
  final NavigationService navigator = NavigationService();
  dynamic token;

  HttpService() {
    _updateHeaders();
  }

  Future postData(
      {required String url,
      Duration timeout = const Duration(seconds: 15)}) async {
    // print('FlexHttpService - postData()');
    http.Response response;
    try {
      await _updateHeaders();
      headers.putIfAbsent('Content-Type', () => 'application/json');
      response =
          await client.post(url.toUri(), headers: headers).timeout(timeout);
    } on Io.SocketException catch (_) {
      // print('FlexHttpService - postData() - ERROR 1 - SocketException');
      throw Exception('Not connected. Socket Exception');
    } on TimeoutException catch (_) {
      // print('FlexHttpService - postData() - ERROR 2 - TimeoutException');
      throw Exception('Timeout Exception');
    } catch (error) {
      // print('FlexHttpService - postData() - ERROR 3 - Exception');
      // print('$error');
      rethrow;
    }

    var data;
    try {
      data = _decodeData(response, forceDecode: true);
    } catch (e) {
      // print('FlexHttpService - fetchData() - ERROR 4 - decodeData');
      // print('FlexHttpService - fetchData() - response.statusCode: "${response.statusCode}"');
      if (e is FormatException) {
        // print('FlexHttpService - fetchData() - ERROR 4 - FormatException');
        throw Exception('${e.message}');
      }
      // print('FlexHttpService - fetchData() - ERROR 4 - Exception');
      rethrow;
    }

    if ((response.statusCode / 100).toStringAsFixed(0) != '2') {
      var error = data['detail'];
      error ??= data['message'];
      throw Exception('$error');
    }
    return data;
  }

  fetchData({
    required String url,
    Map? query,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    // print('HttpService - fetchData() - url: "$url"');
    http.Response response;
    try {
      // await _updateHeaders();
      url = _updateQuery(url);
      // print('...AFTER _updateQuery - url: "$url"');

      if(query != null) {
        for(Map key in query.keys) {
          url+='&''$key=${query[key]}';
        }
      }

      // print('...AFTER custom query - url: "$url"');
      response =
          await client.get(url.toUri(), headers: headers).timeout(timeout);
    } on Io.SocketException catch (_) {
      // print('FlexHttpService - fetchData() - ERROR 1 - SocketException');
      throw Exception('Not connected. Socket Exception');
    } on TimeoutException catch (_) {
      // print('FlexHttpService - fetchData() - ERROR 2 - TimeoutException');
      throw Exception('Timeout Exception');
    } catch (error) {
      // print('FlexHttpService - fetchData() - ERROR 3 - Exception');
      // print('$error');
      rethrow;
    }

    // print('FlexHttpService - fetchData() - response.statusCode: "${response.statusCode}"');
    // print('FlexHttpService - fetchData() - response: "${response.body.toString()}"');

    if (response.statusCode == 204) {
      // print('FlexHttpService - fetchData() - response.statusCode: "${response.statusCode}"');
      // print('FlexHttpService - fetchData() - data [${data.toString()}]');
      return null;
    }

    var data;
    try {
      data = _decodeData(response, forceDecode: true);
    } catch (e) {
      print('FlexHttpService - fetchData() - ERROR - decodeData');
      if (e is FormatException) {
        print('FlexHttpService - fetchData() - ERROR - FormatException');
        throw Exception('${e.message}');
      }
      print('FlexHttpService - fetchData() - ERROR - Exception');
      rethrow;
    }

    // print('FlexHttpService - fetchData() - data: "$data"');
    if (response.statusCode != 200) {
      // print('FlexHttpService - fetchData() - response.statusCode: "${response.statusCode}"');
      // print('FlexHttpService - fetchData() - data [${data.toString()}]');
      var error = data['detail'];
      error ??= data['message'];
      throw Exception('$error');
    }
    return data;
  }

  _updateHeaders() async {
    // print('FlexHttpService - _updateHeaders()...');

    headers.clear();
    // token = await authenticationService.getToken();
    token = tmdbApiKey;
    if (token != null && token != '') {
      headers.putIfAbsent('Authorization', () => 'Bearer $token');

      // GET TOKEN ON CONSOLE
      // List<String> tokenArr = token.split('.');
      // for (int i = 0; i < tokenArr.length; i++) {
      //   print('FlexAuthenticationService - token_$i: -|${tokenArr[i]}|-');
      // }
    }

    headers.putIfAbsent(
        'language', () => Localizations.localeOf(navigator.context).toString());
  }

  String _updateQuery(url) {
    url += '?';
    token = tmdbApiKey;
    url += 'api_key=$token';

    String locale = Localizations.localeOf(navigator.context).toString();
    locale = locale.split('_').first;
    url += '&';
    url += 'language=$locale';

    return url;
  }

  _decodeData(http.Response response, {bool forceDecode = false}) {
    dynamic data;
    if (response.statusCode == 200 || forceDecode) {
      data = json.decode(utf8.decode(response.bodyBytes));
    } else {
      data = [];
    }
    return data;
  }
}
