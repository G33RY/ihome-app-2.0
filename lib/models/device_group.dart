import 'package:flutter/cupertino.dart';
import 'package:ihome/models/device.dart';

class DeviceGroup {
  int id;
  String name;
  DeviceType type;
  List<Device> devices;
  Map<String, dynamic> state;
  DateTime createdAt;
  DateTime updatedAt;

  DeviceGroup({
    required this.id,
    required this.name,
    required this.type,
    required this.devices,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceGroup.fromJson(Map<String, dynamic> json) => DeviceGroup(
        id: json["id"] as int,
        name: json["name"]!.toString(),
        type: DeviceType.values.firstWhere(
          (e) => e.name == json["type"]!.toString(),
        ),
        devices: List<Device>.from(
          (json["devices"] as List<dynamic>).map(
            (x) => Device.fromJson(x as Map<String, dynamic>),
          ),
        ).toList(),
        state: json["state"] as Map<String, dynamic>,
        createdAt: DateTime.parse(json["created_at"].toString()),
        updatedAt: DateTime.parse(json["updated_at"].toString()),
      );

  bool get isOn {
    if (state["on"] == null) {
      return false;
    }

    final dynamic on = state["on"];
    if (on is! bool) {
      return false;
    }

    return on;
  }

  Color? get color {
    if (state["color"] == null) {
      return null;
    }

    final dynamic color = state["color"];
    if (color is! Map<String, dynamic>) {
      return null;
    }

    final num? r = num.tryParse(color['red']?.toString() ?? "");
    final num? g = num.tryParse(color['green']?.toString() ?? "");
    final num? b = num.tryParse(color['blue']?.toString() ?? "");

    if (r == null || g == null || b == null) {
      return null;
    }

    return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 1);
  }

  double? get percentage {
    if (state["percentage"] == null) {
      return null;
    }

    final dynamic percentage = state["percentage"];
    if (percentage is! num) {
      print(percentage);
      return null;
    }

    return percentage.toDouble();
  }
}
