import 'package:flutter/material.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/models/device.dart';
import 'package:ihome/widgets/my_button.dart';

class DeviceWidget extends StatelessWidget {
  Device device;
  final Function() onTap;
  final Function() onLongTap;

  DeviceWidget({
    required this.device,
    required this.onTap,
    required this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle = "";
    if (device.percentage != null) {
      subtitle = "${(device.percentage! * 100).toInt()}%";
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
      onTap: onTap,
      onLongTap: onLongTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
              child: Icon(
                device.type.icon,
                size: 35,
                color: device.isOn ? MyColors.orange : MyColors.gray,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                device.name,
                overflow: TextOverflow.clip,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "SFCompact",
                  fontSize: 18,
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: device.isOn ? MyColors.gray60 : MyColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
