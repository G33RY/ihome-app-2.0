import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/models/setting.dart';
import 'package:ihome/screens/home_screen.dart';
import 'package:ihome/widgets/screen_navigator.dart';
import 'package:ihome/screens/settings_screen.dart';
import 'package:ihome/screens/weather_screen.dart';
import 'package:ihome/widgets/custom_tab_bar.dart';
import 'package:location/location.dart';
import '/generated/l10n.dart';

class App extends StatefulWidget {
  const App();

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return ScreenNavigator(
            screens: [
              ScreenInfo(
                HomeScreen(),
                CupertinoIcons.house_fill,
                "Home",
              ),
              ScreenInfo(
                WeatherScreen(),
                CupertinoIcons.cloud_sun_fill,
                "Weather",
              ),
              ScreenInfo(
                SettingsScreen(),
                CupertinoIcons.settings,
                "Settings",
              ),
            ],
            tabBarBlur: 10,
            tabBackgroundColor: Colors.black.withOpacity(0.3),
            backgroundImage: const AssetImage("assets/images/bg1.jpg"),
            tabSelectedStyle: const TabItemStyle(
              textStyle: TextStyle(
                fontFamily: "SFCompact",
                fontWeight: FontWeight.w400,
                color: MyColors.orange,
                fontSize: 10,
              ),
              iconColor: MyColors.orange,
              iconSIze: 20,
            ),
            tabUnselectedStyle: const TabItemStyle(
              textStyle: TextStyle(
                fontFamily: "SFCompact",
                fontWeight: FontWeight.w400,
                color: MyColors.white60,
                fontSize: 10,
              ),
              iconColor: MyColors.white60,
              iconSIze: 20,
            ),
          );
        }

        return Container();
      },
    );
  }
}

Future<String?> init() async {
  try {
    await Hive.initFlutter(); // Init Hive

    // Register Adapters
    if (!Hive.isAdapterRegistered(SettingAdapter().typeId)) {
      Hive.registerAdapter(SettingAdapter());
    }

    //Init Hive Boxes(Tables)
    try {
      Setting.BOX = await Hive.openBox<Setting>("settings");
    } catch (e) {
      await Hive.deleteBoxFromDisk("settings");
      Setting.BOX = await Hive.openBox<Setting>("settings");
    }

    Utils.canVibrate =
        await Vibrate.canVibrate.onError((error, stackTrace) => false);

    Timer.periodic(const Duration(minutes: 5), (timer) {
      Weather.currentWeather;
      Weather.hourlyForecast;
      Weather.dailyForecast;
    });
    return null;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return e.toString();
  }
}
