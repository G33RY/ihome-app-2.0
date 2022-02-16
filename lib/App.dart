import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/api/api.dart';
import 'package:ihome/models/api/device.dart';
import 'package:ihome/models/api/scene.dart';
import 'package:ihome/models/api/token.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/models/setting.dart';
import 'package:ihome/screens/home_screen.dart';
import 'package:ihome/screens/screen_navigator.dart';
import 'package:ihome/screens/settings_screen.dart';
import 'package:ihome/screens/weather_screen.dart';
import 'package:ihome/widgets/custom_tab_bar.dart';
import 'package:location/location.dart';
import 'package:wakelock/wakelock.dart';
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
        if (snapshot.data == "ok") {
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
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Register Adapters
    if (!Hive.isAdapterRegistered(SettingAdapter().typeId)) {
      Hive.registerAdapter(SettingAdapter());
    }
    if (!Hive.isAdapterRegistered(SceneAdapter().typeId)) {
      Hive.registerAdapter(SceneAdapter());
    }

    //Init Hive Boxes(Tables)
    try {
      Setting.BOX = await Hive.openBox<Setting>("settings");
    } catch (e) {
      await Hive.deleteBoxFromDisk("settings");
      Setting.BOX = await Hive.openBox<Setting>("settings");
    }

    try {
      Scene.BOX = await Hive.openBox<Scene>("scenes");
    } catch (e) {
      await Hive.deleteBoxFromDisk("scenes");
      Scene.BOX = await Hive.openBox<Scene>("scenes");
    }

    Utils.canVibrate =
        await Vibrate.canVibrate.onError((error, stackTrace) => false);

    Timer.periodic(const Duration(minutes: 2), (timer) {
      Weather.currentWeather(true);
      Weather.hourlyForecast(true);
      Weather.dailyForecast(true);
      Device.fetch();
    });
    return "ok";
  } catch (e) {
    print(e);
    return e.toString();
  }
}
