import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/helpers/custom_icons.dart';
import 'package:ihome/models/constants.dart';

enum DeviceType {
  light,
  blinds,
}

abstract class Device {
  late String _id;
  late DeviceType _deviceType;
  late IconData _icon;
  late String _title;
  late bool _isOn;

  Device({
    required String id,
    required DeviceType deviceType,
    required IconData icon,
    required String title,
    required bool isOn,
  }) {
    _id = id;
    _deviceType = deviceType;
    _icon = icon;
    _title = title;
    _isOn = isOn;
  }

  void toggle() {
    isOn = !isOn;
  }

  String get id => _id;
  DeviceType get deviceType => _deviceType;
  IconData get icon => _icon;
  String get title => _title;
  bool get isOn => _isOn;

  set isOn(bool value) {
    print("isOn value changed");
    _isOn = !isOn;
  }

  static Future<List<Device>> get devices async {
    return [
      Light(
        id: "id",
        title: "Movie Mode",
        isOn: true,
        brightness: 0.6,
        color: MyColors.orange,
      ),
      Blinds(
        id: "id1",
        title: "Movie Mode",
        isOn: true,
        percentage: 0.6,
      ),
    ];
  }
}

class Light extends Device {
  late double _brightness;
  late Color _color;
  Light({
    required String id,
    required String title,
    required bool isOn,
    required Color color,
    required double brightness,
  }) : super(
          id: id,
          deviceType: DeviceType.light,
          title: title,
          isOn: isOn,
          icon: CupertinoIcons.lightbulb_fill,
        ) {
    _color = color;
    _brightness = brightness;
  }

  double get brightness => _brightness;
  Color get color => _color;

  set brightness(double value) {
    print("brightess changed");
    _brightness = value;
  }

  set color(Color value) {
    print("color changed");
    _color = value;
  }
}

class Blinds extends Device {
  late double _percentage;
  Blinds({
    required String id,
    required String title,
    required bool isOn,
    required double percentage,
  }) : super(
          id: id,
          deviceType: DeviceType.blinds,
          title: title,
          isOn: isOn,
          icon: CustomIcons.blinds,
        ) {
    _percentage = percentage;
  }

  double get percentage => _percentage;
  set percentage(double value) {
    print("percentage changed");
    _percentage = value;
  }
}
