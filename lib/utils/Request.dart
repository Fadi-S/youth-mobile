import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Request {

  static final String domain = "youth.alsharobim.com";
  static final String fullUrl = "https://" + domain + "/api";
  String url;
  String token;

  var headers;

  Request(String url, {String token}) {
    this.url = url;

    this.token = token;

    this.headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    if(this.token != null)
      this.headers[HttpHeaders.authorizationHeader] = "Bearer " + this.token;
  }

  String getFullUrl() => fullUrl + this.url;

  static Future<String> responseFromStreamed(http.StreamedResponse response) async {
    String responseString = await response.stream.transform(utf8.decoder).join();
    return responseString;
  }

  Future<http.Response> post([Map<String, String> params]) async {
    params = params ?? {};

    var client = http.Client();

    return client.post(fullUrl + url, body: jsonEncode(params), headers: this.headers).whenComplete(client.close);
  }

  Future<http.Response> get({Map<String, String> params}) async {
    var client = http.Client();

    String strParams = "";

    if(params != null)
      params.forEach((String key, String value) {
        if(key == null) return;
        if(value == null) return;
        strParams += key + "=" + value + "&";
      });

    return client.get(fullUrl + url + "?" + strParams, headers: this.headers)
        .whenComplete(client.close);
  }

  static Future<bool> isNetworkAvailable([int timeout=30]) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

      try {
        List<InternetAddress> response = await InternetAddress.lookup(domain);

        return response.isNotEmpty && response[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      } on TimeoutException catch(_) {
        return false;
      }

    }

    return false;
  }

}