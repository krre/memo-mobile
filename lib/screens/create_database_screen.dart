import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memo/db/database.dart';
import 'package:memo/widgets/confirm_dialog.dart';

import 'tree_screen.dart';

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
                    onPressed: () async {
                      if (_name.isEmpty) return;

                      final navigator = Navigator.of(context);
                      bool overwrite = false;

                      while (true) {
                        try {
                          await Db.getInstance()
                              .create(_name, overwrite: overwrite);
                          break;
                        } on DatabaseExistsException catch (_) {
                          bool? result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => ConfirmDialog(
                                    title: l10n.databaseExists,
                                    description: l10n.overwrite,
                                  ));

                          if (result!) {
                            overwrite = true;
                          } else {
                            return;
                          }
                        }
                      }

                      await navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const TreeScreen();
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
