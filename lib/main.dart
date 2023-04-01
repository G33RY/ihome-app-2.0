import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ihome/firebase_options.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'App.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CupertinoApp(
    title: "R2G Flight Client",
    localizationsDelegates: [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      RefreshLocalizations.delegate
    ],
    debugShowCheckedModeBanner: false,
    // supportedLocales: S.delegate.supportedLocales,
    home: App(),
  ));
}
