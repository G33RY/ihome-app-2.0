import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/helpers/cacher.dart';
import 'package:ihome/helpers/custom_icons.dart';
import 'package:ihome/models/api/api.dart';
import 'package:ihome/models/constants.dart';

enum DeviceType {
  light,
  blinds,
}

class Device {
  late String _id;
  late DeviceType _type;
  late String _name;

  late bool _on;
  late double? _percentage;
  late Color? _color;

  Device({
    required String id,
    required DeviceType type,
    required String name,
    required bool on,
    double? percentage,
    Color? color,
  }) {
    _id = id;
    _type = type;
    _name = name;
    _on = on;
    _percentage = percentage;
    _color = color;
  }

  Device.fromJson(String json) {
    dynamic decoded = jsonDecode(json);
    _id = decoded["id"] as String;
    _type = DeviceType.values[decoded["type"] as int];

    _name = decoded["name"] as String;
    _on = decoded["on"] as bool;
    _percentage = decoded["percentage"] as double?;
    _color = decoded["color"] == null ? null : Color(decoded["color"] as int);
  }

  void toggle([bool? value]) {
    isOn = value ?? !isOn;
  }

  void set() {
    isOn = isOn;
    color = color;
    percentage = percentage;
  }

  Map toJSON() => {
        "id": id,
        "type": type.index,
        "name": name,
        "on": _on,
        "percentage": _percentage,
        "color": _color?.value,
      };

  String get id => _id;
  DeviceType get type => _type;
  String get name => _name;
  bool get isOn => _on;
  Color? get color => _color;
  double? get percentage => _percentage;

  set isOn(bool value) {
    IHOMEAPI.POST("devices/toggle", {
      "id": id,
      "on": value,
    });
    _on = value;
  }

  set color(Color? value) {
    if (value != null) {
      IHOMEAPI.POST("devices/color", {
        "id": id,
        "color": {
          "red": value.red,
          "green": value.green,
          "blue": value.blue,
        }
      });
    }
    _color = value;
  }

  set percentage(double? value) {
    if (value != null) {
      IHOMEAPI.POST("devices/percentage", {"id": id, "percentage": value});
    }
    _percentage = value;
  }

  Device clone() {
    return Device(
      id: _id,
      name: _name,
      type: _type,
      on: _on,
      color: _color,
      percentage: _percentage,
    );
  }

  static Future<List<Device>> fetch() async {
    List<Device> devices = [];

    try {
      List<dynamic> json =
          jsonDecode(await IHOMEAPI.GET("devices")) as List<dynamic>;
      for (dynamic jsonDevice in json) {
        Map<String, dynamic> device = jsonDevice as Map<String, dynamic>;
        Map<String, dynamic>? color =
            device["state"]["color"] as Map<String, dynamic>?;
        devices.add(Device(
          id: device["id"] as String,
          type: parseDeviceType(device["type"] as String),
          name: device["name"] as String,
          on: device["state"]["on"] as bool? ?? true,
          percentage: double.tryParse(device["state"]["percentage"].toString()),
          color: color == null
              ? null
              : Color.fromRGBO(
                  int.parse(color["red"].toString()),
                  int.parse(color["green"].toString()),
                  int.parse(color["blue"].toString()),
                  1,
                ),
        ));
      }
    } catch (e) {
      print("devices fetch");
      print(e);
    }

    return devices;
  }
}

extension DeviceTypeExtension on DeviceType {
  IconData get icon {
    switch (this) {
      case DeviceType.light:
        return CupertinoIcons.lightbulb_fill;
      case DeviceType.blinds:
        return CupertinoIcons.list_bullet_indent;
      default:
        return CupertinoIcons.clear_circled_solid;
    }
  }
}

DeviceType parseDeviceType(String type) {
  switch (type) {
    case "blinds":
      return DeviceType.blinds;
    default:
      return DeviceType.light;
  }
}
