import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihome/MainCubit.dart';
import 'package:ihome/api/ihomeapi.dart';
import 'package:ihome/models/weather_current.dart';
import 'package:ihome/models/weather_type.dart';
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
  late RefreshController refreshController;

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    IHOMEAPI.instance?.socket.disconnect();
    IHOMEAPI.instance?.socket.connect();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      onRefresh: _onRefresh,
      physics: const ClampingScrollPhysics(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return Column(
            children: [
              ScreenHeader(
                title: "Gödöllő",
                subtitle: state.weatherCurrent?.desc?.title ?? 'Unknown',
                weather: state.weatherCurrent,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Section(
                        sectionTitle: "Next 48 hours",
                        children: state.weatherHourly
                            .map((e) => ForecastHour(e))
                            .toList(),
                      ),
                      Section(
                        sectionTitle: "Next 7 days",
                        children: state.weatherDaily
                            .map((e) => ForecastDay(e))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
