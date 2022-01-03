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
  final DateTime? sunset;
  final DateTime? sunrise;
  final int? feels;
  final int? pressure;
  final int? humidity;
  final int? clouds;
  final int? visibility;
  final int? windSpeed;
  final int? windDeg;
  final String? title;
  final WeatherType? type;
  final bool? isNight;

  const Weather({
    required this.temp,
    required this.icon,
    required this.time,
    this.minTemp,
    this.type,
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

  //Current Weather
  static Future<Weather> get currentWeather async {
    return Cache.get(
      key: "currentWeather",
      func: () async {
        await Future.delayed(const Duration(seconds: 2));
        final Weather weather = Weather(
          temp: 32,
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
        await Future.delayed(const Duration(seconds: 2));
        final List<Weather> forecast = [
          Weather(
            temp: 69,
            icon: CupertinoIcons.sun_max_fill,
            time: DateTime.now(),
            type: WeatherType.mostlyCloudy,
          ),
          Weather(
            temp: 69,
            icon: CupertinoIcons.sun_max_fill,
            time: DateTime.now(),
            type: WeatherType.mostlyCloudy,
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
        await Future.delayed(const Duration(seconds: 2));
        final List<Weather> forecast = [
          Weather(
            temp: 32,
            minTemp: -320,
            icon: CupertinoIcons.sun_max_fill,
            time: DateTime.now(),
          ),
          Weather(
            temp: 32,
            minTemp: -321,
            icon: CupertinoIcons.sun_max_fill,
            time: DateTime.now(),
            type: WeatherType.misty,
          ),
        ];

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
