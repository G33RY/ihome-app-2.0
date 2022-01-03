import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/widgets/header.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '/generated/l10n.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  Weather? currentWeather;

  @override
  void initState() {
    fetchData();
    timer =
        Timer.periodic(const Duration(minutes: 10), (_timer) => fetchData());
    super.initState();
  }

  Future<void> fetchData() async {
    List<dynamic> futures = await Future.wait<dynamic>([
      Weather.currentWeather,
    ]);

    if (!mounted) return;
    setState(() {
      currentWeather = futures[0] as Weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(
          title: "Settings",
          subtitle: "",
          weather: currentWeather,
        ),
      ],
    );
  }
}
