import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihome/MainCubit.dart';
import 'package:ihome/api/ihomeapi.dart';
import 'package:ihome/models/crypto_token.dart';
import 'package:ihome/models/device.dart';
import 'package:ihome/models/device_group.dart';
import 'package:ihome/models/scene.dart';
import 'package:ihome/models/weather_current.dart';
import 'package:ihome/models/weather_daily.dart';
import 'package:ihome/models/weather_hourly.dart';
import 'package:socket_io_client/socket_io_client.dart';

class WsEvents {
  static WsEvents? _instance;
  WsEvents._();
  static WsEvents get instance {
    _instance ??= WsEvents._();
    return _instance!;
  }

  MainCubit? _mainCubit;

  void onConnect(dynamic _) {
    print("Connected to socket");
  }

  void onDisconnect(dynamic _) {
    print("Disconnected from socket");
  }

  void onSensorData(dynamic data) {
    if (data == null) return;
    if (data is! Map<String, dynamic>) return;

    try {
      String key = data['key'] as String;
      Map<String, dynamic> value = data['data'] as Map<String, dynamic>;
      Map<String, dynamic> sensors = _mainCubit!.state.sensors;
      sensors[key] = value;
      _mainCubit!.setSensors(sensors);
    } catch (e, t) {
      FirebaseCrashlytics.instance.recordError(e, t);
    }
  }

  void onSensorsUpdated(dynamic data) {
    if (data == null) return;
    if (data is! List<dynamic>) return;

    final Map<String, dynamic> sensors = _mainCubit?.state.sensors ?? {};

    for (final sensor in data) {
      if (sensor is! Map<String, dynamic>) continue;
      try {
        String key = sensor['key'] as String;
        Map<String, dynamic> value = sensor['data'] as Map<String, dynamic>;
        sensors[key] = value;
      } catch (e, t) {
        FirebaseCrashlytics.instance.recordError(e, t);
      }
    }

    _mainCubit!.setSensors(sensors);
  }

  void onWeatherCurrent(dynamic data) {
    if (data == null) return;
    if (data is! Map<String, dynamic>) return;

    try {
      _mainCubit!.setWeatherCurrent(WeatherCurrent.fromJson(data));
    } catch (e, t) {
      FirebaseCrashlytics.instance.recordError(e, t);
    }
  }

  void onWeatherHourly(dynamic data) {
    if (data == null) return;
    if (data is! List<dynamic>) return;

    final List<WeatherHourly> weathers = [];
    for (final weather in data) {
      if (weather is! Map<String, dynamic>) continue;
      try {
        weathers.add(WeatherHourly.fromJson(weather));
      } catch (e, t) {
        FirebaseCrashlytics.instance.recordError(e, t);
      }
    }

    _mainCubit!.setWeatherHourly(weathers);
  }

  void onWeatherDaily(dynamic data) {
    if (data == null) return;
    if (data is! List<dynamic>) return;

    final List<WeatherDaily> weathers = [];
    for (final weather in data) {
      if (weather is! Map<String, dynamic>) continue;
      try {
        weathers.add(WeatherDaily.fromJson(weather));
      } catch (e, t) {
        FirebaseCrashlytics.instance.recordError(e, t);
      }
    }

    _mainCubit!.setWeatherDaily(weathers);
  }

  void onCryptosUpdated(dynamic data) {
    if (data == null) return;
    if (data is! List<dynamic>) return;

    final List<CryptoToken> tokens = [];
    for (final token in data) {
      if (token is! Map<String, dynamic>) continue;
      try {
        tokens.add(CryptoToken.fromJson(token));
      } catch (e, t) {
        FirebaseCrashlytics.instance.recordError(e, t);
      }
    }

    _mainCubit!.setCryptoTokens(tokens);
  }

  void onDevicesUpdated(dynamic data) {
    if (data == null) return;
    if (data is! List<dynamic>) return;

    final List<Device> devices = [];
    for (final device in data) {
      if (device is! Map<String, dynamic>) continue;
      try {
        devices.add(Device.fromJson(device));
      } catch (e, t) {
        FirebaseCrashlytics.instance.recordError(e, t);
      }
    }

    _mainCubit!.setDevices(devices);
  }

  void onDeviceGroupsUpdated(dynamic data) {
    if (data == null) return;
    if (data is! List<dynamic>) return;

    final List<DeviceGroup> groups = [];
    for (final group in data) {
      if (group is! Map<String, dynamic>) continue;
      try {
        groups.add(DeviceGroup.fromJson(group));
      } catch (e, t) {
        FirebaseCrashlytics.instance.recordError(e, t);
      }
    }

    _mainCubit!.setDeviceGroups(groups);
  }

  void onScenesUpdated(dynamic data) {
    if (data == null) return;
    if (data is! List<dynamic>) return;

    final List<Scene> scenes = [];
    for (final scene in data) {
      if (scene is! Map<String, dynamic>) continue;
      try {
        scenes.add(Scene.fromJson(scene));
      } catch (e, t) {
        FirebaseCrashlytics.instance.recordError(e, t);
      }
    }

    _mainCubit!.setScenes(scenes);
  }

  void onClientUpdated(dynamic data) {
    if (data == null) return;
    if (data is! Map<String, dynamic>) return;

    try {
      final Map<String, dynamic> settings =
          data['settings'] as Map<String, dynamic>? ?? {};
      _mainCubit!.setSettings(settings);
    } catch (e, t) {
      FirebaseCrashlytics.instance.recordError(e, t);
    }
  }

  void onError(dynamic err) {
    FirebaseCrashlytics.instance.recordError(err, StackTrace.current);
  }

  void registerEvents(MainCubit mainCubit) {
    _mainCubit = mainCubit;
    IHOMEAPI.instance!.socket.onConnect(onConnect);
    IHOMEAPI.instance!.socket.onDisconnect(onDisconnect);
    IHOMEAPI.instance!.socket.onError(onError);
    IHOMEAPI.instance!.socket.on("sensor:data", onSensorData);
    IHOMEAPI.instance!.socket.on("weather:current", onWeatherCurrent);
    IHOMEAPI.instance!.socket.on("weather:hourly", onWeatherHourly);
    IHOMEAPI.instance!.socket.on("weather:daily", onWeatherDaily);
    IHOMEAPI.instance!.socket.on("cryptos:updated", onCryptosUpdated);
    IHOMEAPI.instance!.socket.on("devices:updated", onDevicesUpdated);
    IHOMEAPI.instance!.socket.on("devicegroups:updated", onDeviceGroupsUpdated);
    IHOMEAPI.instance!.socket.on("scenes:updated", onScenesUpdated);
    IHOMEAPI.instance!.socket.on("client:updated", onClientUpdated);
    IHOMEAPI.instance!.socket.on('sensors:updated', onSensorsUpdated);
  }
}
