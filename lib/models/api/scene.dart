import 'package:flutter/cupertino.dart';
import 'package:ihome/models/api/device.dart';

class Scene {
  late IconData _icon;
  late String _title;
  late bool _isOn;
  List<Device> devices = [];

  Scene({
    required IconData icon,
    required String title,
    bool isOn = true,
    List<Device>? devices,
  }) {
    _icon = icon;
    _title = title;
    _isOn = isOn;
    if (devices != null) this.devices = devices;
  }

  IconData get icon => _icon;
  String get title => _title;
  bool get isOn => _isOn;

  set isOn(bool value) {}

  set title(String value) {
    print("Title changed");
    _title = value;
  }

  set icon(IconData value) {
    print("Icon changed");
    _icon = value;
  }

  void remove() {
    print("scene removed");
  }

  void save() {
    print("scene saved");
  }

  static Future<List<Scene>> get scenes async {
    return [
      Scene(
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
    ];
  }

  Scene clone() => Scene(icon: icon, title: title);
}
