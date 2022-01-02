import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/widgets/forecast_day.dart';
import 'package:ihome/widgets/forecast_hour.dart';
import 'package:ihome/widgets/header.dart';
import 'package:ihome/widgets/section.dart';
import 'package:ihome/widgets/value_slider.dart';
import '/generated/l10n.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Timer timer;
  List<Weather> hourlyForecast = [];
  List<Weather> dailyForecast = [];

  @override
  void initState() {
    getData();
    timer = Timer.periodic(const Duration(minutes: 10), (_timer) => getData());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void getData() {
    Weather.hourlyForecast.then((value) {
      if (mounted) {
        setState(() {
          hourlyForecast = value;
        });
      }
    });
    Weather.dailyForecast.then((value) {
      if (mounted) {
        setState(() {
          dailyForecast = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ScreenHeader(
          title: "Gödöllő",
          subtitle: "Clear",
        ),
        Section(
          sectionTitle: "Next 48 hours",
          children: hourlyForecast.map((e) => ForecastHour(e)).toList(),
        ),
        Section(
          sectionTitle: "Next 7 days",
          children: dailyForecast.map((e) => ForecastDay(e)).toList(),
        ),
      ],
    );
  }
}
