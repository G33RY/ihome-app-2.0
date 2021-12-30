import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/widgets/Header.dart';
import '/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ScreenHeader(
          title: "Good Morning!",
          subtitle: "Today's forecast:",
          desc: "High of 23° and low of 4°,\nlight rain until this evening.",
        ),
      ],
    );
  }
}
