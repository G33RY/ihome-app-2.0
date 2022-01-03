import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/api/device.dart';

import 'package:ihome/models/api/scene.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/device.dart';
import 'package:ihome/widgets/icon_picker.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:ihome/widgets/value_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '/generated/l10n.dart';

class SceneModal extends StatefulWidget {
  final Scene scene;
  final Function(Scene scene) onSave;
  final Function() onRemove;
  final List<Device> devices;
  const SceneModal({
    required this.scene,
    required this.onSave,
    required this.devices,
    required this.onRemove,
  });

  @override
  State<StatefulWidget> createState() => _SceneModalState();
}

class _SceneModalState extends State<SceneModal> {
  late TextEditingController titleController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController(text: widget.scene.title);
    titleController.addListener(() {
      widget.scene.title = titleController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      color: Colors.black,
      child: Column(
        children: [
          Container(
            color: MyColors.gray60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Icon(
                    widget.scene.icon,
                    size: 30,
                    color: MyColors.orange,
                  ),
                ),
                Container(
                  child: Text(
                    widget.scene.title,
                    style: const TextStyle(
                      fontFamily: "SFCompact",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                MyButton(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20, bottom: 20, right: 30),
                  boxDecoration: BoxDecoration(
                    color: MyColors.gray60,
                    borderRadius: BorderRadius.circular(300),
                  ),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    size: 18,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.scene.save();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            margin: EdgeInsets.only(
                              bottom: 30,
                              left: 30,
                              right: 30,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.gray60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    right: 20,
                                    left: 10,
                                  ),
                                  child: Icon(
                                    widget.scene.icon,
                                    size: 30,
                                    color: Colors.orange,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    style: const TextStyle(
                                      fontFamily: "SFCompact",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    controller: titleController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.gray60,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconPicker(
                              icon: widget.scene.icon,
                              onChange: (v) {
                                setState(() {
                                  widget.scene.icon = v;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          buildDevices(),
                          buildButtons(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool isSelected(Device device) =>
      widget.scene.devices.any((e) => e.id == device.id);

  Widget buildDevices() {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: MyColors.gray60,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: widget.devices.map((device) {
          String subtitle = "";
          if (device.deviceType == DeviceType.light) {
            Light light = device as Light;
            subtitle = "${(light.brightness * 100).toInt()}%";
          } else if (device.deviceType == DeviceType.blinds) {
            Blinds blinds = device as Blinds;
            subtitle = "${(blinds.percentage * 100).toInt()}%";
          }

          return MyButton(
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 25,
            ),
            boxDecoration: BoxDecoration(
              color: device.isOn ? Colors.white : MyColors.white60,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            right: 15, bottom: 10, top: 5),
                        child: Icon(
                          device.icon,
                          size: 20,
                          color: device.isOn ? MyColors.orange : MyColors.gray,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Icon(
                          isSelected(device)
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          size: 22,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      device.title,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: "SFCompact",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: device.isOn ? Colors.black : MyColors.gray,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: "SFCompact",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: device.isOn ? MyColors.gray60 : MyColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                if (isSelected(device)) {
                  widget.scene.devices.removeWhere((e) => e.id == device.id);
                } else {
                  widget.scene.devices.add(device.clone());
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyButton(
          margin: const EdgeInsets.only(top: 20, right: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: const Text(
            "Save",
            style: TextStyle(
              fontFamily: "SFCompact",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.activeBlue,
            ),
          ),
          onTap: () {
            widget.scene.save();
            widget.onSave.call(widget.scene);
            Navigator.of(context).pop();
          },
        ),
        MyButton(
          margin: const EdgeInsets.only(top: 20, left: 10, right: 30),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: const Text(
            "Remove",
            style: TextStyle(
              fontFamily: "SFCompact",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: MyColors.red,
            ),
          ),
          onTap: () {
            widget.scene.remove();
            widget.onRemove.call();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showSceneModal({
  required BuildContext context,
  required Scene scene,
  required List<Device> devices,
  required Function(Scene scene) onSave,
  required Function() onRemove,
}) {
  showBarModalBottomSheet(
    context: context,
    width: MediaQuery.of(context).size.width * 0.7,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) {
      return SceneModal(
        scene: scene,
        onSave: onSave,
        onRemove: onRemove,
        devices: devices,
      );
    },
    onClose: () {},
  );
}
