import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:ihome/widgets/value_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '/generated/l10n.dart';

class DeviceModal extends StatefulWidget {
  final Device device;
  final Function() onChange;
  const DeviceModal({
    required this.device,
    required this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _DeviceModalState();
}

class _DeviceModalState extends State<DeviceModal> {
  Map<MaterialColor, String> customColorSwatch = {
    ColorTools.createPrimarySwatch(Colors.white): "White",
  };
  Light? light;
  Blinds? blinds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.device.deviceType == DeviceType.light) {
      light = widget.device as Light;
    } else if (widget.device.deviceType == DeviceType.blinds) {
      blinds = widget.device as Blinds;
    }

    if (light != null) {
      Color closestColor = Colors.white;
      double closestColorValue = closestColor.distanceTo(light!.color);

      Colors.primaries.forEach((color) {
        final double d = light!.color.distanceTo(color);
        if (d < closestColorValue) {
          closestColor = color;
          closestColorValue = d;
        }
        customColorSwatch.addAll({
          ColorTools.createPrimarySwatch(color): color.hex,
        });
      });

      light!.color = closestColor;
    }
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
                    widget.device.icon,
                    size: 30,
                    color: MyColors.orange,
                  ),
                ),
                Container(
                  child: Text(
                    widget.device.title,
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
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  if (light != null) ...[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ColorPicker(
                            color: light!.color,
                            enableShadesSelection: false,
                            pickersEnabled: const {
                              ColorPickerType.accent: false,
                              ColorPickerType.primary: false,
                              ColorPickerType.custom: true,
                            },
                            onColorChanged: (Color value) {
                              setState(() {
                                if (light != null) {
                                  light!.color = value;
                                  widget.onChange.call();
                                }
                              });
                            },
                            borderRadius: 30,
                            width: 60,
                            height: 60,
                            spacing: 20,
                            runSpacing: 20,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            customColorSwatchesAndNames: customColorSwatch,
                          ),
                        ],
                      ),
                    ),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ValueSlider(
                          width: 200,
                          height: 400,
                          onChange: (v) {
                            if (light != null) {
                              light!.brightness = v;
                              if (v == 0) {
                                light!.isOn = false;
                              } else if (!light!.isOn) {
                                light!.isOn = true;
                              }
                            } else if (blinds != null) {
                              blinds!.percentage = v;
                              if (v == 0) {
                                blinds!.isOn = false;
                              } else if (!blinds!.isOn) {
                                blinds!.isOn = true;
                              }
                            }
                            widget.onChange.call();
                          },
                          value: light?.brightness ?? (blinds?.percentage ?? 0),
                          color: light?.color ?? Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

void showDeviceModal(BuildContext context, Device device, Function() onChange) {
  showBarModalBottomSheet(
    context: context,
    width: MediaQuery.of(context).size.width * 0.7,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) {
      return DeviceModal(device: device, onChange: onChange);
    },
  );
}
