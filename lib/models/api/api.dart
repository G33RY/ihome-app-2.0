import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ihome/helpers/cacher.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/api/token.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/constants.dart';

mixin IHOMEAPI {
  static String _AUTH =
      base64Encode(utf8.encode("g33ry:WDgMVUwoti8SorcpK4V6b8PqWfJWFibvMPJK"));
  static String _BASEURL = "http://192.168.0.5/api";

  static Future<String> GET(String suburl) async {
    Response response = await get(
      Uri.parse("${_BASEURL}/${suburl}"),
      headers: {
        "Authorization": "Basic ${_AUTH}",
      },
    ).catchError(
      (e) {
        print(e);
      },
    );
    return response.body;
  }

  static Future<Response> POST(String suburl, Map<String, dynamic> body) async {
    return post(
      Uri.parse("$_BASEURL/$suburl"),
      body: jsonEncode(body),
      headers: {
        "Authorization": "Basic $_AUTH",
        "Content-Type": "application/json",
      },
    ).catchError(
      (e) {
        print(e);
      },
    );
  }
}
