import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/helpers/cacher.dart';

const Duration cacheDuration = Duration(minutes: 5);

class Weather {
  final int temp;
  final int? minTemp;
  final IconData icon;
  final DateTime time;

  const Weather({
    required this.temp,
    required this.icon,
    required this.time,
    this.minTemp,
  });

  //Current Weather
  static Future<Weather> get currentWeather async {
    return Cache.get(
      key: "currentWeather",
      func: () async {
        await Future.delayed(const Duration(seconds: 10));
        final Weather weather = Weather(
          temp: 69,
          icon: CupertinoIcons.sun_max_fill,
          time: DateTime.now(),
        );

        return weather;
      },
    );
  }

  //Hourly Weather
  static Future<List<Weather>> get hourlyForecast async {
    return Cache.get<List<Weather>>(
      key: "hourlyForecast",
      func: () async {
        await Future.delayed(const Duration(seconds: 10));
        final List<Weather> forecast = [
          Weather(
            temp: 69,
            icon: CupertinoIcons.sun_max_fill,
            time: DateTime.now(),
          ),
        ];

        return forecast;
      },
    );
  }

  //Daily Weather
  static Future<List<Weather>> get dailyForecast async {
    return Cache.get<List<Weather>>(
      key: "dailyForecast",
      func: () async {
        await Future.delayed(const Duration(seconds: 10));
        final List<Weather> forecast = [
          Weather(
            temp: 69,
            minTemp: 10,
            icon: CupertinoIcons.sun_max_fill,
            time: DateTime.now(),
          ),
        ];

        return forecast;
      },
    );
  }
}
