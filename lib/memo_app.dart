import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memo/helpers/preferences.dart';
import 'package:memo/screens/tree/tree_screen.dart';

import 'screens/start_screen.dart';

class MemoApp extends StatelessWidget {
  const MemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Memo',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
        ],
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: FutureBuilder(
          future: Preferences.getDbName(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            return snapshot.data == null
                ? const StartScreen()
                : const TreeScreen();
          },
        ));
  }
}
