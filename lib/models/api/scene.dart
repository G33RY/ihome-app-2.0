import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:ihome/models/api/device.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 2)
class Scene extends HiveObject {
  static late Box<Scene> BOX;
  late String _id;
  late IconData _icon;
  late String _title;
  late bool _isOn;
  List<Device> devices = [];

  Scene({
    required IconData icon,
    required String title,
    bool isOn = true,
    String? id,
    List<Device>? devices,
  }) {
    _id = id ?? const Uuid().v4();
    _icon = icon;
    _title = title;
    _isOn = isOn;
    if (devices != null) this.devices = devices;
  }

  Scene.fromJson(String json) {
    dynamic decoded = jsonDecode(json);
    _id = decoded["id"] as String;
    _title = decoded["title"] as String;
    _isOn = decoded["isOn"] as bool;

    Map icon = decoded["icon"] as Map;
    _icon = IconData(
      icon["codePoint"] as int,
      fontFamily: icon["fontFamily"] as String,
      fontPackage: icon["fontPackage"] as String,
    );

    List d = jsonDecode(decoded["devices"] as String) as List;
    for (var device in d) {
      devices.add(Device.fromJson(jsonEncode(device)));
    }
  }

  String get id => _id;
  IconData get icon => _icon;
  String get title => _title;
  bool get isOn => _isOn;

  set isOn(bool value) {}

  set title(String value) {
    _title = value;
  }

  set icon(IconData value) {
    _icon = value;
  }

  void remove() {
    Scene.BOX.delete(id);
  }

  void run() {
    for (final device in devices) {
      device.set();
    }
  }

  Object toJSON() => {
        "icon": {
          "codePoint": icon.codePoint,
          "fontFamily": icon.fontFamily,
          "fontPackage": icon.fontPackage,
        },
        "id": _id,
        "isOn": _isOn,
        "title": _title,
        "devices": jsonEncode(devices.map((e) => e.toJSON()).toList()),
      };

  @override
  String toString() => jsonEncode(toJSON());

  static Future<List<Scene>> get scenes async {
    return Scene.BOX.values.toList();
  }

  Scene clone() => Scene(icon: icon, title: title, devices: devices, id: id);
}

class SceneAdapter extends TypeAdapter<Scene> {
  @override
  final typeId = 2;

  @override
  Scene read(BinaryReader reader) {
    return Scene.fromJson(reader.read().toString());
  }

  @override
  void write(BinaryWriter writer, Scene obj) {
    writer.write(obj.toString());
  }
}
