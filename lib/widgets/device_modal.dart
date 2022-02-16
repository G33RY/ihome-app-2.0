import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/color_picker.dart';
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
  List<Color> customColors = [
    const Color.fromRGBO(255, 000, 064, 1),
    const Color.fromRGBO(255, 000, 128, 1),
    const Color.fromRGBO(255, 000, 192, 1),
    const Color.fromRGBO(255, 000, 255, 1),
    const Color.fromRGBO(192, 000, 255, 1),
    const Color.fromRGBO(128, 000, 255, 1),
    const Color.fromRGBO(064, 000, 255, 1),
    const Color.fromRGBO(000, 000, 255, 1),
    const Color.fromRGBO(000, 064, 255, 1),
    const Color.fromRGBO(000, 128, 255, 1),
    const Color.fromRGBO(000, 192, 255, 1),
    const Color.fromRGBO(000, 255, 255, 1),
    const Color.fromRGBO(000, 255, 192, 1),
    const Color.fromRGBO(000, 255, 128, 1),
    const Color.fromRGBO(000, 255, 064, 1),
    const Color.fromRGBO(000, 255, 000, 1),
    const Color.fromRGBO(064, 255, 000, 1),
    const Color.fromRGBO(128, 255, 000, 1),
    const Color.fromRGBO(192, 255, 000, 1),
    const Color.fromRGBO(255, 255, 000, 1),
    const Color.fromRGBO(255, 192, 000, 1),
    const Color.fromRGBO(255, 128, 000, 1),
    const Color.fromRGBO(255, 064, 000, 1),
    const Color.fromRGBO(255, 000, 000, 1),
    const Color.fromRGBO(255, 255, 255, 1),
  ].reversed.toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
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
                    widget.device.type.icon,
                    size: 30,
                    color: MyColors.orange,
                  ),
                ),
                Text(
                  widget.device.name,
                  style: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          if (widget.device.color != null) ...[
                            ColorPicker(
                              color: widget.device.color,
                              colors: customColors,
                              onChange: (Color value) {
                                setState(() {
                                  widget.device.color = value;
                                  widget.onChange.call();
                                });
                              },
                              borderRadius: 30,
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          if (widget.device.percentage != null) ...[
                            ValueSlider(
                              width: 200,
                              height: 400,
                              onChange: (v) {
                                widget.device.percentage = v;
                                if (v == 0) {
                                  if (widget.device.isOn) {
                                    widget.device.isOn = false;
                                  }
                                } else {
                                  if (!widget.device.isOn) {
                                    widget.device.isOn = true;
                                  }
                                }
                                widget.onChange.call();
                              },
                              value: widget.device.percentage ?? 0,
                              color: widget.device.color ?? Colors.white,
                            ),
                          ]
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
}

void showDeviceModal(BuildContext context, Device device, Function() onChange) {
  States.popupActive = true;
  showBarModalBottomSheet(
    context: context,
    width: MediaQuery.of(context).size.width * 0.7,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) {
      return DeviceModal(device: device, onChange: onChange);
    },
    onClose: () {
      States.popupActive = false;
    },
  );
}
