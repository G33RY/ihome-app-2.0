// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Monday`
  String get Monday {
    return Intl.message(
      'Monday',
      name: 'Monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get Tuesday {
    return Intl.message(
      'Tuesday',
      name: 'Tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get Wednesday {
    return Intl.message(
      'Wednesday',
      name: 'Wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get Thursday {
    return Intl.message(
      'Thursday',
      name: 'Thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get Friday {
    return Intl.message(
      'Friday',
      name: 'Friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get Saturday {
    return Intl.message(
      'Saturday',
      name: 'Saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get Sunday {
    return Intl.message(
      'Sunday',
      name: 'Sunday',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get January {
    return Intl.message(
      'January',
      name: 'January',
      desc: '',
      args: [],
    );
  }

  /// `February`
  String get February {
    return Intl.message(
      'February',
      name: 'February',
      desc: '',
      args: [],
    );
  }

  /// `March`
  String get March {
    return Intl.message(
      'March',
      name: 'March',
      desc: '',
      args: [],
    );
  }

  /// `April`
  String get April {
    return Intl.message(
      'April',
      name: 'April',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get May {
    return Intl.message(
      'May',
      name: 'May',
      desc: '',
      args: [],
    );
  }

  /// `June`
  String get June {
    return Intl.message(
      'June',
      name: 'June',
      desc: '',
      args: [],
    );
  }

  /// `July`
  String get July {
    return Intl.message(
      'July',
      name: 'July',
      desc: '',
      args: [],
    );
  }

  /// `August`
  String get August {
    return Intl.message(
      'August',
      name: 'August',
      desc: '',
      args: [],
    );
  }

  /// `September`
  String get September {
    return Intl.message(
      'September',
      name: 'September',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get October {
    return Intl.message(
      'October',
      name: 'October',
      desc: '',
      args: [],
    );
  }

  /// `November`
  String get November {
    return Intl.message(
      'November',
      name: 'November',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get December {
    return Intl.message(
      'December',
      name: 'December',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
