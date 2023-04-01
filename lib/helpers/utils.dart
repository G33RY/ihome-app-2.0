import 'dart:math';

import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DeviceInfo {
  String name;
  String id;
  DeviceInfo({required this.name, required this.id});
}

mixin Utils {
  static late bool canVibrate;

  static List<int> makeRange(int min, int max) {
    List<int> range = [];

    for (int i = min; i <= max; i++) {
      range.add(i);
    }

    return range;
  }

  static Future<void> setBrightness(double brightness) async {
    try {
      print("setBrightness: $brightness");
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      print(e);
      throw 'Failed to set brightness';
    }
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension GetOnIndexExtension<E> on List<E> {
  E? get(int index) {
    if (index < 0 || index >= this.length) return null;
    return this[index];
  }
}

extension ColorDistanceExtension on Color {
  Color closestColor(List<Color> colors) {
    double closestDistance = 999999;
    int index = 0;
    for (int i = 0; i < colors.length; i++) {
      Color color = colors[i];
      double distance = color.distanceTo(this);
      if (distance < closestDistance) {
        closestDistance = distance;
        index = i;
      }
    }

    return colors[index];
  }

  double distanceTo(Color color) {
    final double r = pow((red - color.red) * 0.3, 2).toDouble();
    final double g = pow((green - color.green) * 0.59, 2).toDouble();
    final double b = pow((blue - color.blue) * 0.11, 2).toDouble();
    return sqrt(r + g + b);
  }
}
