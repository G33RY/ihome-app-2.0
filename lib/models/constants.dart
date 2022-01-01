import 'package:flutter/material.dart';
import 'package:ihome/generated/l10n.dart';

mixin MyColors {
  static const Color orange = Color.fromRGBO(255, 159, 10, 1);
  static const Color smokewhite = Color.fromRGBO(235, 235, 245, 1);
  static const Color white60 = Color.fromRGBO(255, 255, 255, 0.6);
  static const Color gray = Color.fromRGBO(99, 99, 102, 1);
  static const Color gray60 = Color.fromRGBO(60, 60, 67, 0.6);

  static const Color red = Color.fromRGBO(255, 69, 58, 1);
}

enum Months {
  January,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December,
}

enum WeekDays {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

extension MonthExtension on Months {
  String getTranslation(BuildContext context) {
    switch (this) {
      case Months.January:
        return S.of(context).January;
      case Months.February:
        return S.of(context).February;
      case Months.March:
        return S.of(context).March;
      case Months.April:
        return S.of(context).April;
      case Months.May:
        return S.of(context).May;
      case Months.June:
        return S.of(context).June;
      case Months.July:
        return S.of(context).July;
      case Months.August:
        return S.of(context).August;
      case Months.September:
        return S.of(context).September;
      case Months.October:
        return S.of(context).October;
      case Months.November:
        return S.of(context).November;
      case Months.December:
        return S.of(context).December;
      default:
        return "";
    }
  }
}

extension WeekDaysExtension on WeekDays {
  String getTranslation(BuildContext context) {
    switch (this) {
      case WeekDays.Monday:
        return S.of(context).Monday;
      case WeekDays.Tuesday:
        return S.of(context).Tuesday;
      case WeekDays.Wednesday:
        return S.of(context).Wednesday;
      case WeekDays.Thursday:
        return S.of(context).Thursday;
      case WeekDays.Friday:
        return S.of(context).Friday;
      case WeekDays.Saturday:
        return S.of(context).Saturday;
      case WeekDays.Sunday:
        return S.of(context).Sunday;
    }
  }
}
