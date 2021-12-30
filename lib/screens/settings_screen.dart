import 'package:flutter/material.dart';
import 'package:ihome/widgets/Header.dart';
import '/generated/l10n.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ScreenHeader(
          title: "Settings",
          subtitle: "",
        ),
      ],
    );
  }
}
