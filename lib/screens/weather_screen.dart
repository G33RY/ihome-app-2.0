import 'package:flutter/material.dart';
import 'package:ihome/widgets/Header.dart';
import 'package:ihome/widgets/value_slider.dart';
import '/generated/l10n.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ScreenHeader(
          title: "Gödöllő",
          subtitle: "Clear",
        ),
      ],
    );
  }
}
