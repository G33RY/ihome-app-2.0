import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/api/api.dart';
import 'package:ihome/models/api/token.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/models/setting.dart';
import 'package:intl/intl.dart';
import '/generated/l10n.dart';

class OfflineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  Weather? weather;
  Token? token;
  DateTime time = DateTime.now();
  Timer? timer1;
  Timer? timer2;

  @override
  void dispose() {
    timer1?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Weather.currentWeather().then((v) {
      setState(() {
        weather = v;
      });
    });

    timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time = DateTime.now();
      });
    });

    timer2 = Timer.periodic(const Duration(minutes: 5), (timer) {
      Token.fetchOne([Setting.getValueByKey("token_shown", "1").toString()])
          .then((tokens) {
        setState(() {
          if (tokens.isNotEmpty) token = tokens[0];
        });
      });
      Weather.currentWeather().then((v) {
        setState(() {
          weather = v;
        });
      });
    });

    Token.fetchOne([Setting.getValueByKey("token_shown", "1").toString()])
        .then((tokens) {
      setState(() {
        if (tokens.isNotEmpty) token = tokens[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Setting.getValueByKey("clock_mode", false) == false) {
      return Container(
        color: Colors.black,
      );
    }
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    weather?.type.icon,
                    size: 60,
                    color: MyColors.orange,
                  ),
                ),
                Text(
                  "${weather?.temp.toInt() ?? "-"} °C",
                  style: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 60,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 130,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${time.year} ${Months.values[time.month - 1].name} ${time.day.toString().padLeft(2, '0')}, ${WeekDays.values[time.weekday - 1].name}",
                  style: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Image.network(
                    token?.logo ??
                        "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                Text(
                  "\$${parsePrice(token?.price ?? 0)}",
                  style: const TextStyle(
                    fontFamily: "SFCompact",
                    fontSize: 60,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String parsePrice(double price) {
    List<String> splitted = price.toString().split('.');
    int decimalCount = splitted[0].length;
    String s = "${splitted[0]}";

    if (splitted[1] == "0") {
      return NumberFormat('#,###').format(price);
    }
    if (splitted[0].length < 2) {
      return price.toStringAsFixed(4);
    }

    if (splitted[0].length < 3) {
      return price.toStringAsFixed(2);
    }

    return NumberFormat('#,###').format(price);
  }
}
