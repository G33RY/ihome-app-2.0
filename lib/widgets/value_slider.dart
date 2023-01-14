import 'dart:math';

import 'package:flutter/material.dart';
import '/generated/l10n.dart';

class ValueSlider extends StatefulWidget {
  final double width;
  final double height;
  Color color;
  double value;
  final Function(double value) onChange;

  ValueSlider({
    required this.width,
    required this.height,
    required this.onChange,
    this.value = 0,
    this.color = Colors.white,
  });
  @override
  State<StatefulWidget> createState() => _ValueSliderState();
}

class _ValueSliderState extends State<ValueSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            final double v = 1 -
                (details.localPosition.dy.clamp(0, widget.height) /
                    widget.height);

            setState(() {
              widget.value = v;
            });
          },
          onVerticalDragEnd: (details) {
            widget.onChange.call(widget.value);
          },
          onTapUp: (details) {
            widget.onChange.call(widget.value);
          },
          onTapDown: (details) {
            final double v = 1 -
                (details.localPosition.dy.clamp(0, widget.height) /
                    widget.height);

            setState(() {
              widget.value = v;
            });
          },
          child: Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: widget.value,
                  child: Container(
                    color: widget.color.withOpacity(0.6),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    "${(widget.value * 100).toInt()}%",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "SFCompact",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
