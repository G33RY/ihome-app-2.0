import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/api/scene.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/header.dart';
import 'package:ihome/widgets/device_modal.dart';
import 'package:ihome/widgets/scene_modal.dart';
import 'package:ihome/widgets/value_slider.dart';
import 'package:ihome/widgets/device.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:ihome/widgets/scene.dart';
import 'package:ihome/widgets/section.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer timer;
  late RefreshController refreshController;
  String title = "";
  String subtitle = "";
  String desc = "";
  List<Scene> scenes = [];
  List<Device> devices = [];

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
    setState(() {
      title = "Good Morning!";
      subtitle = "Today's forecast:";
      desc = "High of 23° and low of 4°,\nlight rain until this evening.";
    });

    fetchData();
    timer = Timer.periodic(const Duration(minutes: 1), (_timer) => fetchData());
  }

  Future<void> fetchData() async {
    List<List<dynamic>> futures = await Future.wait<List<dynamic>>([
      Scene.scenes,
      Device.devices,
    ]);

    setState(() {
      scenes = futures[0] as List<Scene>;
      devices = futures[1] as List<Device>;
    });
  }

  Future<void> _onRefresh() async {
    await fetchData();
    refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    timer.cancel();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      onRefresh: _onRefresh,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          ScreenHeader(
            title: title,
            subtitle: subtitle,
            desc: desc,
          ),
          Section(
            sectionTitle: "Favourite Scenes",
            sectionButtonIcon: CupertinoIcons.add_circled_solid,
            onTap: () {
              showSceneModal(
                context: context,
                scene: Scene(
                  icon: CupertinoIcons.house_fill,
                  title: "New Scene",
                ),
                devices: devices,
                onSave: (_scene) {
                  setState(() {
                    scenes.add(_scene);
                  });
                },
                onRemove: () {},
              );
            },
            children: scenes.map((scene) {
              return SceneWidget(
                scene: scene,
                onTap: () {},
                onLongTap: () {
                  showSceneModal(
                    context: context,
                    scene: scene.clone(),
                    devices: devices,
                    onSave: (_scene) {
                      setState(() {
                        scene = _scene;
                      });
                    },
                    onRemove: () {
                      setState(() {
                        scenes.removeWhere(
                          (e) => e == scene,
                        );
                      });
                    },
                  );
                },
              );
            }).toList(),
          ),
          Section(
            sectionTitle: "Devices",
            children: devices.map((device) {
              return DeviceWidget(
                device: device,
                onTap: () {
                  print("change on tap");
                },
                onLongTap: () {
                  showDeviceModal(context, device, () {
                    setState(() {});
                    print("change on longtap");
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
