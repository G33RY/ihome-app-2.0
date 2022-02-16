import 'package:flutter/material.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/widgets/my_button.dart';
import '/generated/l10n.dart';

class ColorPicker extends StatefulWidget {
  List<Color> colors;
  Color? color;
  double width;
  double height;
  double borderRadius;
  EdgeInsets padding;
  Function(Color color)? onChange;

  ColorPicker({
    required this.colors,
    this.color,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 0,
    this.width = 32,
    this.height = 32,
    this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color? selected;

  @override
  void initState() {
    selected = widget.color?.closestColor(widget.colors);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: widget.colors.map((color) {
          return MyButton(
            margin: widget.padding,
            boxDecoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            width: widget.width,
            height: widget.height,
            child: selected == color
                ? Icon(
                    Icons.check,
                    size: widget.width / 2,
                    color: Colors.black,
                  )
                : null,
            onTap: () {
              setState(() {
                selected = color;
                widget.onChange?.call(color);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
