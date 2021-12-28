import 'package:flutter/material.dart';
import '/generated/l10n.dart';

class PageControl extends StatelessWidget {
  final int pageCount;
  final double size;
  final double horizontalMargin;
  final int currentIndex;
  final Color selectedColor;
  final Color unselectedColor;

  const PageControl({
    required this.currentIndex,
    required this.pageCount,
    required this.size,
    required this.horizontalMargin,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < pageCount; i++) ...[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: i == currentIndex ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(size),
            ),
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          )
        ]
      ],
    );
  }
}
