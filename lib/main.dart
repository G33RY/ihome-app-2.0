import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'App.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const CupertinoApp(
    title: "R2G Flight Client",
    localizationsDelegates: [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    // supportedLocales: S.delegate.supportedLocales,
    home: App(),
  ));
}
