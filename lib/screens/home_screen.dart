import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/api/scene.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/Header.dart';
import 'package:ihome/widgets/device_modal.dart';
import 'package:ihome/widgets/value_slider.dart';
import 'package:ihome/widgets/device.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:ihome/widgets/scene.dart';
import 'package:ihome/widgets/section.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "";
  String subtitle = "";
  String desc = "";
  List<Scene> scenes = [];
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      title = "Good Morning!";
      subtitle = "Today's forecast:";
      desc = "High of 23° and low of 4°,\nlight rain until this evening.";
    });

    Scene.scenes.then((value) {
      setState(() {
        scenes = value;
      });
    });

    Device.devices.then((value) {
      setState(() {
        devices = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(
          title: title,
          subtitle: subtitle,
          desc: desc,
        ),
        Section(
          sectionTitle: "Favourite Scenes",
          sectionButtonIcon: CupertinoIcons.add_circled_solid,
          children: scenes.map((scene) {
            return SceneWidget(
              scene: scene,
              onTap: (_scene) {},
              onLongTap: (_scene) {},
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
                showDeviceModal(context, device, (device) {
                  setState(() {});
                  print("change on longtap");
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
