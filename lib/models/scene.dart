import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Scene {
  int id;
  IconData? icon;
  String name;
  bool isOn;

  Scene({
    required this.id,
    required this.name,
    required this.icon,
    required this.isOn,
  });

  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: parseIcon(json['icon'] as String),
      isOn: json['is_on'] as int == 1,
    );
  }

  static IconData parseIcon(String icon) {
    switch (icon) {
      case "sunset_fill":
        return CupertinoIcons.sunset_fill;
      case "sunrise_fill":
        return CupertinoIcons.sunrise_fill;
      case "house_fill":
        return CupertinoIcons.house_fill;
      case "home":
        return CupertinoIcons.house_fill;
      case "clock_fill":
        return CupertinoIcons.clock_fill;
      case "tv_fill":
        return CupertinoIcons.tv_fill;
      case "game_controller_solid":
        return CupertinoIcons.game_controller_solid;
      case "person_fill":
        return CupertinoIcons.person_fill;
      case "play_circle_fill":
        return CupertinoIcons.play_circle_fill;
      case "money_dollar":
        return CupertinoIcons.money_dollar;
      case "alarm_fill":
        return CupertinoIcons.alarm_fill;
      case "heart_fill":
        return CupertinoIcons.heart_fill;
      case "bed_double_fill":
        return CupertinoIcons.bed_double_fill;
      case "zzz":
        return CupertinoIcons.zzz;
    }
    return CupertinoIcons.house_fill;
  }
}
