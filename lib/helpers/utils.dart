import 'dart:math';

import 'package:flutter/material.dart';

class DeviceInfo {
  String name;
  String id;
  DeviceInfo({required this.name, required this.id});
}

mixin Utils {
  static late bool canVibrate;
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
  double distanceTo(Color color) {
    double r = pow((red - color.red) * 0.3, 2).toDouble();
    double g = pow((green - color.green) * 0.59, 2).toDouble();
    double b = pow((blue - color.blue) * 0.11, 2).toDouble();
    return sqrt(r + g + b);
  }
}
