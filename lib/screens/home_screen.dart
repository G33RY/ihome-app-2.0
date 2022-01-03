import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/api/scene.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/header.dart';
import 'package:ihome/widgets/device_modal.dart';
import 'package:ihome/widgets/scene_modal.dart';
import 'package:ihome/widgets/value_slider.dart';
import 'package:ihome/widgets/device.dart';
import 'package:ihome/widgets/my_button.dart';
import 'package:ihome/widgets/scene.dart';
import 'package:ihome/widgets/section.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer timer;
  late RefreshController refreshController;
  String title = "";
  String subtitle = "";
  String desc = "";
  Weather? currentWeather;
  List<Scene> scenes = [];
  List<Device> devices = [];

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
    setState(() {
      title = "Hi!";
      subtitle = "";
      desc = "";
    });

    fetchData();
    timer = Timer.periodic(const Duration(minutes: 1), (_timer) => fetchData());
  }

  Future<void> setHeaderTexts() async {
    final DateTime time = DateTime.now();
    final List<Weather> dailyForecast = await Weather.dailyForecast;

    if (!mounted) return;

    //Tomorrow's forecast
    if (time.hour <= 3 || time.hour >= 18) {
      Weather? tomorrowWeather;
      String expected = "";
      if (dailyForecast.length > 1) {
        tomorrowWeather = dailyForecast[1];
        print(tomorrowWeather);
      }

      switch (tomorrowWeather?.type) {
        case WeatherType.cloudy:
          expected = "clouds are expected";
          break;
        case WeatherType.fewClouds:
          expected = "few clouds are expected";
          break;
        case WeatherType.rain:
          expected = "light rain is expected";
          break;
        case WeatherType.showerRain:
          expected = "heavy rain is expected";
          break;
        case WeatherType.snow:
          expected = "snow is expected";
          break;
        case WeatherType.thunderstorm:
          expected = "thunderstorm is expected";
          break;
        case WeatherType.mostlyCloudy:
          expected = "lot of clouds are expected";
          break;
        case WeatherType.misty:
          expected = "fog is expected";
          break;
        default:
      }

      setState(() {
        if (mounted) {
          subtitle = "Tomorrow's forecast:";
          desc =
              "High of ${tomorrowWeather?.temp ?? '- '}° and low of ${tomorrowWeather?.minTemp ?? '- '}°${expected == "" ? "" : ',\n$expected'}";
        }
      });
    }

    //Today's forecast
    if (time.hour > 3 && time.hour < 18) {
      Weather? todayWeather;
      String expected = "";
      if (dailyForecast.isNotEmpty) {
        todayWeather = dailyForecast[0];
      }

      switch (todayWeather?.type) {
        case WeatherType.cloudy:
          expected = "clouds are expected";
          break;
        case WeatherType.fewClouds:
          expected = "few clouds are expected";
          break;
        case WeatherType.rain:
          expected = "light rain is expected";
          break;
        case WeatherType.showerRain:
          expected = "heavy rain is expected";
          break;
        case WeatherType.snow:
          expected = "snow is expected";
          break;
        case WeatherType.thunderstorm:
          expected = "thunderstorm is expected";
          break;
        case WeatherType.mostlyCloudy:
          expected = "lot of clouds are expected";
          break;
        case WeatherType.misty:
          expected = "fog is expected";
          break;
        default:
      }

      setState(() {
        subtitle = "Today's forecast:";
        desc =
            "High of ${todayWeather?.temp ?? '- '}° and low of ${todayWeather?.minTemp ?? '- '}°${expected == "" ? "" : ',\n$expected'}";
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

  Future<void> fetchData() async {
    setHeaderTexts();
    List<dynamic> futures = await Future.wait<dynamic>([
      Scene.scenes,
      Device.devices,
      Weather.currentWeather,
    ]);

    if (!mounted) return;
    setState(() {
      scenes = futures[0] as List<Scene>;
      devices = futures[1] as List<Device>;
      currentWeather = futures[2] as Weather;
    });
  }

  Future<void> _onRefresh() async {
    await fetchData();
    refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    timer.cancel();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      onRefresh: _onRefresh,
      physics: const ClampingScrollPhysics(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ScreenHeader(
              title: title,
              subtitle: subtitle,
              desc: desc,
              weather: currentWeather,
            ),
            Section(
              sectionTitle: "Favourite Scenes",
              sectionButtonIcon: CupertinoIcons.add_circled_solid,
              onTap: () {
                showSceneModal(
                  context: context,
                  scene: Scene(
                    icon: CupertinoIcons.house_fill,
                    title: "New Scene",
                  ),
                  devices: devices,
                  onSave: (_scene) {
                    setState(() {
                      scenes.add(_scene);
                    });
                  },
                  onRemove: () {},
                );
              },
              children: scenes.map((scene) {
                return SceneWidget(
                  scene: scene,
                  onTap: () {},
                  onLongTap: () {
                    showSceneModal(
                      context: context,
                      scene: scene.clone(),
                      devices: devices,
                      onSave: (_scene) {
                        setState(() {
                          scene = _scene;
                        });
                      },
                      onRemove: () {
                        setState(() {
                          scenes.removeWhere(
                            (e) => e == scene,
                          );
                        });
                      },
                    );
                  },
                );
              }).toList(),
            ),
            Section(
              sectionTitle: "Devices",
              children: devices.map((device) {
                return DeviceWidget(
                  device: device,
                  onTap: () {
                    print("change on tap");
                  },
                  onLongTap: () {
                    showDeviceModal(context, device, () {
                      setState(() {});
                      print("change on longtap");
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
