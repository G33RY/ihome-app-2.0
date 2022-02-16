import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/api.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/setting.dart';
import 'package:ihome/widgets/header.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:ihome/widgets/section.dart';
import 'package:ihome/widgets/setting_box.dart';
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
      Weather.currentWeather(),
    ]);

    if (!mounted) return;
    setState(() {
      currentWeather = futures[0] as Weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenHeader(
          title: "Settings",
          subtitle: "",
          weather: currentWeather,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 64,
                      ),
                      child: SettingWidget(
                        title: "Clock Mode",
                        type: SettingWidgetType.toggle,
                        value:
                            Setting.getValueByKey("clock_mode", false) as bool,
                        onChange: (v) {
                          setState(() {
                            Setting.saveValue("clock_mode", v);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 64,
                      ),
                      child: SettingWidget(
                        title: "Timeout",
                        suffix: "sec",
                        type: SettingWidgetType.number,
                        value: Setting.getValueByKey("timeout", 15),
                        onChange: (v) {
                          Setting.saveValue("timeout", v);
                        },
                      ),
                    ),
                  ],
                ),
                if (Setting.getValueByKey("clock_mode", false) as bool) ...[
                  Section(
                    sectionTitle: "Clock mode settings",
                    direction: Axis.vertical,
                    children: [
                      SettingWidget(
                        title: "Force dim screen",
                        type: SettingWidgetType.toggle,
                        value:
                            Setting.getValueByKey("force_dim", false) as bool,
                        onChange: (v) {
                          setState(() {
                            Setting.saveValue("force_dim", v);
                          });
                        },
                      ),
                      SettingWidget(
                        title: "Dim Brightness",
                        type: SettingWidgetType.number,
                        value: Setting.getValueByKey("brightness", 30),
                        max: 100,
                        onChange: (v) {
                          Setting.saveValue("brightness", v);
                        },
                      ),
                      SettingWidget(
                        title: "Wake screen at",
                        type: SettingWidgetType.time,
                        value: Setting.getValueByKey("wake_at", [6, 0]),
                        onChange: (v) {
                          Setting.saveValue("wake_at", v);
                        },
                      ),
                      SettingWidget(
                        title: "Dim screen at",
                        type: SettingWidgetType.time,
                        value: Setting.getValueByKey("dim_at", [22, 0]),
                        onChange: (v) {
                          Setting.saveValue("dim_at", v);
                        },
                      ),
                      SettingWidget(
                        title: "Token shown",
                        type: SettingWidgetType.token,
                        value: Setting.getValueByKey("token_shown", "1"),
                        onChange: (v) {
                          Setting.saveValue("token_shown", v);
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        )
      ],
    );
  }
}
