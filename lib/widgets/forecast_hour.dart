import 'package:flutter/material.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/models/weather_hourly.dart';
import 'package:ihome/models/weather_type.dart';
import '/generated/l10n.dart';

class ForecastHour extends StatelessWidget {
  final WeatherHourly weather;
  const ForecastHour(this.weather);

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
            "${weather.date.hour.toString().padLeft(2, "0")}:${weather.date.minute.toString().padLeft(2, "0")}",
            style: const TextStyle(
              fontFamily: "SFCompact",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            _getDay(weather.date, context),
            style: const TextStyle(
              fontFamily: "SFCompact",
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5, top: 10),
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _getDay(DateTime date, BuildContext context) {
    final int today = DateTime.now().day;
    if (date.day == today) {
      return "Today";
    }
    if (date.day == today + 1) {
      return "Tomorrow";
    }

    return WeekDays.values[date.weekday - 1].getTranslation(context);
  }
}
