import 'package:flutter/material.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/models/weather_daily.dart';
import 'package:ihome/models/weather_type.dart';
import '/generated/l10n.dart';

class ForecastDay extends StatelessWidget {
  final WeatherDaily weather;

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
        minWidth: 180,
      ),
      child: Column(
        children: [
          Text(
            WeekDays.values[weather.date.weekday - 1].name,
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
              weather.desc.icon,
              size: 45,
              color: MyColors.orange,
            ),
          ),
          Text(
            "${weather.temp?.toInt() ?? "-"}°C",
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
              "${weather.temp_min?.toInt() ?? "-"}°C",
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
