import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    List<List<Weather>> futures = await Future.wait<List<Weather>>([
      Weather.hourlyForecast,
      Weather.dailyForecast,
    ]);

    setState(() {
      if (mounted) {
        hourlyForecast = futures[0];
        dailyForecast = futures[1];
      }
    });
  }

  Future<void> _onRefresh() async {
    print("refresh");
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
      ),
    );
  }
}
