import 'dart:convert';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ihome/api/ws_events.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:settings_bundle/settings_bundle.dart';

class IHOMEAPI {
  static IHOMEAPI? _instance;

  late IO.Socket socket;
  late String _authToken;
  late String _baseUrl;

  IHOMEAPI._();
  static IHOMEAPI? get instance {
    return _instance;
  }

  static Future<void> init() async {
    String token =
        "cbHN4jKBf1ftwXFTHT3wr0?Z1VFGSaksfyZVSVXsvX9Ag=!K9YWeeimOb7T-h!-9";
    String wsUrl = "http://192.168.0.5";
    String baseUrl = "http://192.168.0.5/api";

    if (Platform.isIOS) {
      token = await SettingsBundle().get<String>('authToken') ?? token;
      wsUrl = await SettingsBundle().get<String>('wsUrl') ?? wsUrl;
      baseUrl = await SettingsBundle().get<String>('baseUrl') ?? baseUrl;
    }
    if (Platform.isAndroid) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString("authToken") ?? token;
      wsUrl = prefs.getString("wsUrl") ?? wsUrl;
      baseUrl = prefs.getString("baseUrl") ?? baseUrl;
      await prefs.setString("token", token);
      await prefs.setString("wsUrl", wsUrl);
      await prefs.setString("baseUrl", baseUrl);
    }

    _instance = IHOMEAPI._();
    _instance!._baseUrl = baseUrl;
    _instance!._authToken = token;

    _instance!.socket = IO.io(
      wsUrl,
      IO.OptionBuilder()
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(172800) // 2 days
          .setTimeout(1000)
          .setTransports(['websocket'])
          .setReconnectionDelay(1000)
          .setExtraHeaders({
            "Authorization": "Bearer $token",
          })
          .build(),
    );
  }

  Future<String> get(String suburl) async {
    final http.Response response = await http.get(
      Uri.parse("$_baseUrl/$suburl"),
      headers: {
        "Authorization": "Bearer $_authToken",
      },
    ).catchError(
      (e) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      },
    );
    return response.body;
  }

  Future<http.Response> post(
    String suburl,
    Map<String, dynamic> body,
  ) async {
    return http.post(
      Uri.parse("$_baseUrl/$suburl"),
      body: jsonEncode(body),
      headers: {
        "Authorization": "Bearer $_authToken",
        "Content-Type": "application/json",
      },
    ).catchError(
      (e) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      },
    );
  }
}
