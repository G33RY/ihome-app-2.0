import 'package:flutter/cupertino.dart';

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

  String get expected {
    switch (this) {
      case WeatherType.cloudy:
        return "clouds are expected";
      case WeatherType.fewClouds:
        return "few clouds are expected";
      case WeatherType.rain:
        return "light rain is expected";
      case WeatherType.showerRain:
        return "heavy rain is expected";
      case WeatherType.snow:
        return "snow is expected";
      case WeatherType.thunderstorm:
        return "thunderstorm is expected";
      case WeatherType.mostlyCloudy:
        return "lot of clouds are expected";
      case WeatherType.misty:
        return "fog is expected";
      default:
        return "";
    }
  }

  String get title {
    switch (this) {
      case WeatherType.cloudy:
        return "Cloudy";
      case WeatherType.fewClouds:
        return "Few Clouds";
      case WeatherType.rain:
        return "Rain";
      case WeatherType.showerRain:
        return "Shower Rain";
      case WeatherType.snow:
        return "Snow";
      case WeatherType.thunderstorm:
        return "Thunderstorm";
      case WeatherType.mostlyCloudy:
        return "Mostly Cloudy";
      case WeatherType.misty:
        return "Misty";
      default:
        return "";
    }
  }
}
