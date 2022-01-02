import 'package:flutter/material.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/models/constants.dart';
import '/generated/l10n.dart';

class ForecastDay extends StatelessWidget {
  final Weather weather;

  const ForecastDay(this.weather);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      constraints: const BoxConstraints(
        minWidth: 100,
      ),
      child: Column(
        children: [
          Text(
            WeekDays.values[weather.time.weekday - 1].name,
            style: const TextStyle(
              fontFamily: "SFCompact",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15, top: 10),
            child: Icon(
              weather.icon,
              size: 45,
              color: MyColors.orange,
            ),
          ),
          Text(
            "${weather.temp}°C",
            style: const TextStyle(
              fontFamily: "SFCompact",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              "${weather.minTemp}°C",
              style: const TextStyle(
                fontFamily: "SFCompact",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: MyColors.gray60,
              ),
            ),
          )
        ],
      ),
    );
  }
}
