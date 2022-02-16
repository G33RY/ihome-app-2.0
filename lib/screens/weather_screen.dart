import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/api/api.dart';
import 'package:ihome/models/api/weather.dart';
import 'package:ihome/widgets/forecast_day.dart';
import 'package:ihome/widgets/forecast_hour.dart';
import 'package:ihome/widgets/header.dart';
import 'package:ihome/widgets/section.dart';
import 'package:ihome/widgets/value_slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/generated/l10n.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Timer timer;
  late RefreshController refreshController;
  List<Weather> hourlyForecast = [];
  List<Weather> dailyForecast = [];
  Weather? currentWeather;

  @override
  void initState() {
    refreshController = RefreshController();

    fetchData();
    timer =
        Timer.periodic(const Duration(minutes: 10), (_timer) => fetchData());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    refreshController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    List<dynamic> futures = await Future.wait<dynamic>([
      Weather.hourlyForecast(),
      Weather.dailyForecast(),
      Weather.currentWeather(),
    ]);

    if (mounted) {
      setState(() {
        hourlyForecast = futures[0] as List<Weather>;
        dailyForecast = futures[1] as List<Weather>;
        currentWeather = futures[2] as Weather;
      });
    }
  }

  Future<void> _onRefresh() async {
    await fetchData();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      onRefresh: _onRefresh,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          ScreenHeader(
            title: "Gödöllő",
            subtitle: currentWeather?.title ?? 'Unknown',
            weather: currentWeather,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Section(
                    sectionTitle: "Next 48 hours",
                    children:
                        hourlyForecast.map((e) => ForecastHour(e)).toList(),
                  ),
                  Section(
                    sectionTitle: "Next 7 days",
                    children: dailyForecast.map((e) => ForecastDay(e)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
