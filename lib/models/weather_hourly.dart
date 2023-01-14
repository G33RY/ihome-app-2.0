import 'package:flutter/cupertino.dart';
import 'package:ihome/models/weather_type.dart';

class WeatherHourly {
  final DateTime date;
  final double? temp;
  final double? feels;
  final double? pressure;
  final double? humidity;
  final double? clouds;
  final double? visibility;
  final double? wind_speed;
  final double? wind_deg;
  final WeatherType desc;

  WeatherHourly({
    required this.date,
    required this.temp,
    required this.feels,
    required this.pressure,
    required this.humidity,
    required this.clouds,
    required this.visibility,
    required this.wind_speed,
    required this.wind_deg,
    required this.desc,
  });

  factory WeatherHourly.fromJson(Map<String, dynamic> json) => WeatherHourly(
        date: DateTime.tryParse(json['date']!.toString())!.toLocal(),
        temp: double.tryParse(json['temp']?.toString() ?? ''),
        feels: double.tryParse(json['feels']?.toString() ?? ''),
        pressure: double.tryParse(json['pressure']?.toString() ?? ''),
        humidity: double.tryParse(json['humidity']?.toString() ?? ''),
        clouds: double.tryParse(json['clouds']?.toString() ?? ''),
        visibility: double.tryParse(json['visibility']?.toString() ?? ''),
        wind_speed: double.tryParse(json['wind_speed']?.toString() ?? ''),
        wind_deg: double.tryParse(json['wind_deg']?.toString() ?? ''),
        desc: WeatherType.values[(json["desc"]["type"] as int) - 1],
      );
}
