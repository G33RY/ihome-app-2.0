import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihome/MainCubit.dart';
import 'package:ihome/api/ihomeapi.dart';
import 'package:ihome/models/device_group.dart';
import 'package:ihome/models/weather_daily.dart';
import 'package:ihome/models/weather_type.dart';
import 'package:ihome/widgets/device.dart';
import 'package:ihome/widgets/device_group.dart';
import 'package:ihome/widgets/device_group_modal.dart';
import 'package:ihome/widgets/device_modal.dart';
import 'package:ihome/widgets/header.dart';
import 'package:ihome/widgets/scene.dart';
import 'package:ihome/widgets/section.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RefreshController refreshController;
  String title = "";
  String subtitle = "";
  String desc = "";

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
    setHeaderTexts(BlocProvider.of<MainCubit>(context).state);
  }

  Future<void> setHeaderTexts(MainState mainState) async {
    final DateTime time = DateTime.now();

    if (!mounted) return;

    //Tomorrow's forecast
    if (time.hour <= 3 || time.hour >= 18) {
      WeatherDaily? tomorrowWeather;
      if (mainState.weatherDaily.length > 1) {
        tomorrowWeather = mainState.weatherDaily[1];
      }
      final String expected = tomorrowWeather?.desc.expected ?? "";

      setState(() {
        if (mounted) {
          subtitle = "Tomorrow's forecast:";
          desc =
              "High of ${tomorrowWeather?.temp?.toInt() ?? '- '}° and low of ${tomorrowWeather?.temp_min?.toInt() ?? '- '}°${expected == "" ? "" : ',\n$expected'}";
        }
      });
    }

    //Today's forecast
    if (time.hour > 3 && time.hour < 18) {
      WeatherDaily? todayWeather;
      if (mainState.weatherDaily.isNotEmpty) {
        todayWeather = mainState.weatherDaily[0];
      }
      final String expected = todayWeather?.desc.expected ?? "";

      setState(() {
        subtitle = "Today's forecast:";
        desc =
            "High of ${todayWeather?.temp?.toInt() ?? '- '}° and low of ${todayWeather?.temp_min?.toInt() ?? '- '}°${expected == "" ? "" : ',\n$expected'}";
      });
    }

    //Set Greetings
    setState(() {
      if (time.hour <= 3 || time.hour >= 21) {
        title = "Good Night!";
      } else if (time.hour > 3 && time.hour < 13) {
        title = "Good Morning!";
      } else if (time.hour >= 13 && time.hour < 17) {
        title = "Good Afternoon!";
      } else if (time.hour >= 17 && time.hour < 21) {
        title = "Good Evening!";
      } else {
        title = "Hi!";
      }
    });
  }

  Future<void> _onRefresh() async {
    IHOMEAPI.instance?.socket.disconnect();
    IHOMEAPI.instance?.socket.connect();
    refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      onRefresh: _onRefresh,
      physics: const ClampingScrollPhysics(),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          setHeaderTexts(state);
        },
        builder: (context, state) {
          return Column(
            children: [
              ScreenHeader(
                title: title,
                subtitle: subtitle,
                desc: desc,
              ),
              Expanded(
                child: Column(
                  children: [
                    Section(
                      sectionTitle: "Favourite Scenes",
                      children: state.scenes.map((scene) {
                        return SceneWidget(
                          scene: scene,
                          onTap: () {
                            IHOMEAPI.instance?.socket
                                .emit("scene:run", scene.id);
                          },
                          onLongTap: () {},
                        );
                      }).toList(),
                    ),
                    Section(
                      sectionTitle: "Devices",
                      children: [
                        ...state.deviceGroups.map((group) {
                          return DeviceGroupWidget(
                            group: group,
                            onTap: () {
                              IHOMEAPI.instance?.socket
                                  .emit("devicegroup:toggle", {
                                "id": group.id,
                                "value": !group.isOn,
                              });
                            },
                            onLongTap: () {
                              showDeviceGroupModal(context, group, () {});
                            },
                          );
                        }).toList(),
                        ...state.devices.map((device) {
                          return DeviceWidget(
                            device: device,
                            onTap: () {
                              IHOMEAPI.instance?.socket.emit("device:toggle", {
                                "id": device.id,
                                "value": !device.isOn,
                              });
                            },
                            onLongTap: () {
                              showDeviceModal(context, device, () {});
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
