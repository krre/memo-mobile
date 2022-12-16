import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memo/helpers/preferences.dart';

import 'notes_screen.dart';

class CreateDatabaseScreen extends StatefulWidget {
  const CreateDatabaseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateDatabaseScreenState();
}

class _CreateDatabaseScreenState extends State<CreateDatabaseScreen> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.createDatabase)),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  onChanged: (text) => _name = text,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n!.name,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_name.isEmpty) return;
                      Preferences.setDbPath(_name);

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const NotesScreen();
                      }), (r) {
                        return false;
                      });
                    },
                    child: Text(l10n.ok))
              ]),
        ),
      ),
    );
  }
}
