import 'package:flutter/material.dart';
import '/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.7),
      width: MediaQuery.of(context).size.width,
      height: 500,
    );
  }
}
