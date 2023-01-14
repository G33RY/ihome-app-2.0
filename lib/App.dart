import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ihome/MainCubit.dart';
import 'package:ihome/api/ihomeapi.dart';
import 'package:ihome/api/ws_events.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/screens/home_screen.dart';
import 'package:ihome/screens/screen_navigator.dart';
import 'package:ihome/screens/weather_screen.dart';
import 'package:ihome/widgets/custom_tab_bar.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wakelock/wakelock.dart';

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
          return BlocProvider(
            create: (_) {
              final cubit = MainCubit();
              WsEvents.instance.registerEvents(cubit);
              return cubit;
            },
            child: ScreenNavigator(
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
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    await IHOMEAPI.init(); // Init API

    Utils.canVibrate =
        await Vibrate.canVibrate.onError((error, stackTrace) => false);

    return "ok";
  } catch (e, t) {
    FirebaseCrashlytics.instance.recordError(e, t);
    print(e);
    print(t);
    return e.toString();
  }
}
