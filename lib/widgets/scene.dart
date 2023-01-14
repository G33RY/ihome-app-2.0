import 'package:flutter/material.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/widgets/my_button.dart';
import '../models/scene.dart';
import '/generated/l10n.dart';

class SceneWidget extends StatefulWidget {
  final Scene scene;
  final Function() onTap;
  final Function() onLongTap;
  const SceneWidget({
    required this.scene,
    required this.onTap,
    required this.onLongTap,
  });

  @override
  State<StatefulWidget> createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  @override
  Widget build(BuildContext context) {
    return MyButton(
      margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      boxDecoration: BoxDecoration(
        color: widget.scene.isOn ? Colors.white : MyColors.white60,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        width: 200,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: Icon(
                widget.scene.icon,
                size: 24,
                color: widget.scene.isOn ? MyColors.orange : MyColors.gray,
              ),
            ),
            Expanded(
              child: Text(
                widget.scene.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "SFCompact",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.scene.isOn ? Colors.black : MyColors.gray,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          widget.onTap.call();
        });
      },
      onLongTap: () {
        widget.onLongTap.call();
      },
    );
  }
}
