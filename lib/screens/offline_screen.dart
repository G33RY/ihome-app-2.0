import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihome/MainCubit.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/models/crypto_token.dart';
import 'package:intl/intl.dart';
import 'package:ihome/models/weather_type.dart';
import '/generated/l10n.dart';

class OfflineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  DateTime time = DateTime.now();
  Timer? timer1;

  @override
  void dispose() {
    timer1?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        if ((state.getSetting('clock_mode', false)) == false) {
          return Container(
            color: Colors.black,
          );
        }

        CryptoToken? token = state.cryptoTokens.firstWhereOrNull(
          (t) =>
              t.symbol.toLowerCase() ==
              state.getSetting('crypto_token', "").toString().toLowerCase(),
        );
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
                        state.weatherCurrent?.desc?.icon ?? Icons.error,
                        size: 60,
                        color: MyColors.orange,
                      ),
                    ),
                    Text(
                      "${state.weatherCurrent?.temp?.toInt() ?? "-"} °C",
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
      },
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
