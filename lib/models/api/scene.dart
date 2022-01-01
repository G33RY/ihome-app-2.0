import 'package:flutter/cupertino.dart';

class Scene {
  final String id;
  IconData icon;
  String title;
  bool isOn;

  Scene({
    required this.id,
    required this.icon,
    required this.title,
    required this.isOn,
  });

  static Future<List<Scene>> get scenes async {
    return [
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
      Scene(
        id: "id",
        icon: CupertinoIcons.tv_fill,
        title: "Movie Mode",
        isOn: true,
      ),
    ];
  }
}
