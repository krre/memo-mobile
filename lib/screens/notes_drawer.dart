import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memo/helpers/preferences.dart';
import 'package:memo/screens/start_screen.dart';

class NotesDrawer extends StatelessWidget {
  const NotesDrawer({super.key});

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
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(l10n.exit),
            onTap: () {
              Preferences.clearDbPath();

              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
