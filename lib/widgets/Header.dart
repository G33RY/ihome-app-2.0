import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/constants.dart';
import '/generated/l10n.dart';

class ScreenHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? desc;
  final Weather? weather;

  const ScreenHeader({
    required this.title,
    required this.subtitle,
    required this.weather,
    this.desc,
  });

  @override
  State<StatefulWidget> createState() => _ScreenHeaderState();
}

class _ScreenHeaderState extends State<ScreenHeader> {
  late Timer timer;
  DateTime today = DateTime.now();

  @override
  void initState() {
    timer = Timer.periodic(const Duration(minutes: 1), (_timer) {
      setState(() {
        if (mounted) {
          today = DateTime.now();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  bool get isLarge => widget.desc == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: isLarge ? 50 : 40,
                    fontWeight: isLarge ? FontWeight.w400 : FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: isLarge ? 5 : 30, bottom: 5),
                  child: Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontFamily: "SFCompact",
                      fontSize: isLarge ? 30 : 25,
                      fontWeight: isLarge ? FontWeight.w600 : FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLarge) ...[
                  Text(
                    widget.desc!,
                    style: TextStyle(
                      fontFamily: "SFCompact",
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Icon(
                          widget.weather?.type.icon ??
                              CupertinoIcons.question_circle_fill,
                          color: MyColors.orange,
                          size: 48,
                        ),
                      ),
                      Text(
                        "${widget.weather?.temp.toInt() ?? '- '}°C",
                        style: TextStyle(
                          fontFamily: "SFCompact",
                          fontSize: 60,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${today.year} ${Months.values[today.month - 1].getTranslation(context)} ${today.day}.\n${WeekDays.values[today.weekday - 1].getTranslation(context)}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
