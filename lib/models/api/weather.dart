import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/helpers/cacher.dart';
import 'package:ihome/models/api/api.dart';

const Duration cacheDuration = Duration(minutes: 5);

class Weather {
  final double temp;
  final WeatherType type;
  final double? minTemp;
  final double? maxTemp;
  final DateTime time;
  final DateTime? sunset;
  final DateTime? sunrise;
  final double? feels;
  final double? pressure;
  final double? humidity;
  final double? clouds;
  final double? visibility;
  final double? windSpeed;
  final double? windDeg;
  final String? title;
  final bool? isNight;

  const Weather({
    required this.temp,
    required this.type,
    required this.time,
    this.minTemp,
    this.maxTemp,
    this.isNight,
    this.title,
    this.feels,
    this.sunrise,
    this.sunset,
    this.pressure,
    this.humidity,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
  });

  static Future<Weather> currentWeather([bool force = false]) async {
    return Cache.get(
      key: "currentWeather",
      force: force,
      func: () async {
        List<Weather> forecast = [];
        try {
          dynamic item =
              jsonDecode(await IHOMEAPI.GET("weather/current")) as dynamic;

          return Weather(
            temp: double.parse(item["temp"].toString()),
            type: WeatherType.values[(item["desc"]["type"] as int) - 1],
            time: DateTime.fromMillisecondsSinceEpoch(item["date"] as int),
            clouds: double.parse(item["clouds"].toString()),
            pressure: double.parse(item["pressure"].toString()),
            humidity: double.parse(item["humidity"].toString()),
            visibility: double.parse(item["visibility"].toString()),
            windSpeed: double.parse(item["wind_speed"].toString()),
            windDeg: double.parse(item["wind_deg"].toString()),
            title: item["desc"]["title"] as String,
            isNight: item["desc"]["is_night"] as bool,
          );
        } catch (e) {
          print(e);
        }

        return Weather(temp: 0, type: WeatherType.clear, time: DateTime.now());
      },
    );
  }

  static Future<List<Weather>> hourlyForecast([bool force = false]) async {
    return Cache.get<List<Weather>>(
      key: "hourlyForecast",
      force: force,
      func: () async {
        List<Weather> forecast = [];
        try {
          List<dynamic> json =
              jsonDecode(await IHOMEAPI.GET("weather/hourly")) as List<dynamic>;

          for (final item in json) {
            forecast.add(Weather(
              temp: double.parse(item["temp"].toString()),
              type: WeatherType.values[(item["desc"]["type"] as int) - 1],
              time: DateTime.fromMillisecondsSinceEpoch(item["date"] as int),
              clouds: double.parse(item["clouds"].toString()),
              feels: double.parse(item["feels"].toString()),
              pressure: double.parse(item["pressure"].toString()),
              humidity: double.parse(item["humidity"].toString()),
              visibility: double.parse(item["visibility"].toString()),
              windSpeed: double.parse(item["wind_speed"].toString()),
              windDeg: double.parse(item["wind_deg"].toString()),
              title: item["desc"]["title"] as String,
              isNight: item["desc"]["is_night"] as bool,
            ));
          }
        } catch (e) {
          print(e);
        }

        return forecast;
      },
    );
  }

  static Future<List<Weather>> dailyForecast([bool force = false]) async {
    return Cache.get<List<Weather>>(
      key: "dailyForecast",
      force: force,
      func: () async {
        List<Weather> forecast = [];
        try {
          List<dynamic> json =
              jsonDecode(await IHOMEAPI.GET("weather/daily")) as List<dynamic>;

          for (final item in json) {
            forecast.add(Weather(
              type: WeatherType.values[(item["desc"]["type"] as int) - 1],
              time: DateTime.fromMillisecondsSinceEpoch(item["date"] as int),
              sunrise:
                  DateTime.fromMillisecondsSinceEpoch(item["sunrise"] as int),
              sunset:
                  DateTime.fromMillisecondsSinceEpoch(item["sunset"] as int),
              temp: double.parse(item["temp"].toString()),
              minTemp: double.parse(item["temp_min"].toString()),
              maxTemp: double.parse(item["temp_max"].toString()),
              clouds: double.parse(item["clouds"].toString()),
              feels: double.parse(item["feels"].toString()),
              pressure: double.parse(item["pressure"].toString()),
              humidity: double.parse(item["humidity"].toString()),
              windSpeed: double.parse(item["wind_speed"].toString()),
              windDeg: double.parse(item["wind_deg"].toString()),
              title: item["desc"]["title"] as String,
              isNight: item["desc"]["is_night"] as bool,
            ));
          }
        } catch (e) {
          print(e);
        }

        return forecast;
      },
    );
  }
}

enum WeatherType {
  clear,
  fewClouds,
  mostlyCloudy,
  cloudy,
  showerRain,
  rain,
  thunderstorm,
  snow,
  misty
}

extension WeatherIconExtension on WeatherType {
  IconData get icon {
    switch (this) {
      case WeatherType.clear:
        return CupertinoIcons.sun_max_fill;
      case WeatherType.fewClouds:
        return CupertinoIcons.cloud_sun_fill;
      case WeatherType.mostlyCloudy:
        return CupertinoIcons.cloud_fill;
      case WeatherType.cloudy:
        return CupertinoIcons.cloud_fill;
      case WeatherType.showerRain:
        return CupertinoIcons.cloud_rain_fill;
      case WeatherType.rain:
        return CupertinoIcons.cloud_sun_rain_fill;
      case WeatherType.thunderstorm:
        return CupertinoIcons.cloud_bolt_rain_fill;
      case WeatherType.snow:
        return CupertinoIcons.snow;
      case WeatherType.misty:
        return CupertinoIcons.cloud_fog_fill;
    }
  }
}
