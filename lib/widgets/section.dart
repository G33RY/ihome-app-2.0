import 'package:flutter/material.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/my_button.dart';
import '/generated/l10n.dart';

class Section extends StatelessWidget {
  final String sectionTitle;
  final IconData? sectionButtonIcon;
  final Function()? onTap;
  final List<Widget> children;

  const Section({
    required this.sectionTitle,
    required this.children,
    this.sectionButtonIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 64),
            child: Row(
              children: [
                Text(
                  sectionTitle,
                  style: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: MyColors.smokewhite,
                  ),
                ),
                if (sectionButtonIcon != null) ...[
                  MyButton(
                    margin: const EdgeInsets.only(left: 10),
                    child: Icon(
                      sectionButtonIcon,
                      size: 30,
                      color: MyColors.smokewhite,
                    ),
                    onTap: onTap,
                  ),
                ],
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i == 0) ...[
                    Container(
                      margin: const EdgeInsets.only(left: 64),
                      child: children[i],
                    ),
                  ] else ...[
                    children[i]
                  ],
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}
