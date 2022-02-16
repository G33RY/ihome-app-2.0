import 'package:flutter/material.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/my_button.dart';
import '/generated/l10n.dart';

class DeviceWidget extends StatefulWidget {
  final Device device;
  final Function() onTap;
  final Function() onLongTap;
  const DeviceWidget({
    required this.device,
    required this.onTap,
    required this.onLongTap,
  });

  @override
  State<StatefulWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String subtitle = "";
    subtitle = "${((widget.device.percentage ?? 0) * 100).toInt()}%";

    return MyButton(
      margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 25,
      ),
      boxDecoration: BoxDecoration(
        color: widget.device.isOn ? Colors.white : MyColors.white60,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
              child: Icon(
                widget.device.type.icon,
                size: 35,
                color: widget.device.isOn ? MyColors.orange : MyColors.gray,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                widget.device.name,
                overflow: TextOverflow.clip,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "SFCompact",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.device.isOn ? Colors.black : MyColors.gray,
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
                color: widget.device.isOn ? MyColors.gray60 : MyColors.gray,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          widget.device.toggle();
          widget.onTap();
        });
      },
      onLongTap: () => widget.onLongTap(),
    );
  }
}
