import 'package:flutter/cupertino.dart';

enum DeviceType {
  light,
}

extension DeviceTypeExtension on DeviceType {
  IconData get icon {
    switch (this) {
      case DeviceType.light:
        return CupertinoIcons.lightbulb_fill;
      default:
        return CupertinoIcons.clear_circled_solid;
    }
  }
}

class Device {
  String id;
  String name;
  DeviceType type;
  String worker;
  Map<String, dynamic> state;
  bool disabled;
  DateTime createdAt;
  DateTime updatedAt;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.worker,
    required this.state,
    required this.disabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"]!.toString(),
        name: json["name"]!.toString(),
        type: DeviceType.values.firstWhere(
          (e) => e.name == json["type"]!.toString(),
        ),
        disabled: json["disabled"] as int == 1,
        worker: json["worker"]!.toString(),
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

    print("r: $r, g: $g, b: $b");

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
      return null;
    }

    return percentage.toDouble();
  }
}
