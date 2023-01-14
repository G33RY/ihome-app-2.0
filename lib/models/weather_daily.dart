import 'package:flutter/cupertino.dart';
import 'package:ihome/models/weather_type.dart';

class WeatherDaily {
  final DateTime date;
  final DateTime sunrise;
  final DateTime sunset;
  final double? temp;
  final double? temp_min;
  final double? temp_max;
  final double? feels;
  final double? pressure;
  final double? humidity;
  final double? clouds;
  final double? wind_speed;
  final double? wind_deg;
  final WeatherType desc;

  WeatherDaily({
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.temp_min,
    required this.temp_max,
    required this.feels,
    required this.pressure,
    required this.humidity,
    required this.clouds,
    required this.wind_speed,
    required this.wind_deg,
    required this.desc,
  });

  factory WeatherDaily.fromJson(Map<String, dynamic> json) => WeatherDaily(
        date: DateTime.tryParse(json['date']!.toString())!.toLocal(),
        sunrise: DateTime.tryParse(json['sunrise']!.toString())!.toLocal(),
        sunset: DateTime.tryParse(json['sunset']!.toString())!.toLocal(),
        temp: double.tryParse(json['temp']!.toString()),
        temp_min: double.tryParse(json['temp_min']!.toString()),
        temp_max: double.tryParse(json['temp_max']!.toString()),
        feels: double.tryParse(json['feels']!.toString()),
        pressure: double.tryParse(json['pressure']!.toString()),
        humidity: double.tryParse(json['humidity']!.toString()),
        clouds: double.tryParse(json['clouds']!.toString()),
        wind_speed: double.tryParse(json['wind_speed']!.toString()),
        wind_deg: double.tryParse(json['wind_deg']!.toString()),
        desc: WeatherType.values[(json["desc"]["type"] as int) - 1],
      );
}
