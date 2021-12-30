import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Duration cacheDuration = Duration(minutes: 5);

class Weather {
  final int temp;
  final IconData icon;

  const Weather({
    required this.temp,
    required this.icon,
  });

  static Weather? lastWeather;
  static DateTime? lastWeatherRequested;
  static Future<Weather> get weather async {
    if (lastWeather == null) return _getWeather();

    if (lastWeatherRequested
            ?.isBefore(DateTime.now().subtract(cacheDuration)) ??
        true) {
      return _getWeather();
    } else {
      return lastWeather!;
    }
  }

  static Future<Weather> _getWeather() async {
    await Future.delayed(const Duration(seconds: 10));
    const Weather weather =
        Weather(temp: 69, icon: CupertinoIcons.sun_max_fill);

    lastWeather = weather;
    lastWeatherRequested = DateTime.now();
    return weather;
  }
}
