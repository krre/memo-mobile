import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memo/helpers/preferences.dart';
import 'package:memo/screens/start_screen.dart';

class TreeDrawer extends StatelessWidget {
  const TreeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: Text(l10n!.database),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StartScreen(),
              ));
            },
          ),
          ListTile(
            title: Text(l10n.exit),
            onTap: () {
              Preferences.clearDbName();

              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
          ),
        ],
      ),
    );
  }
}
