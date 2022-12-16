import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'notes_screen.dart';

class ConnectDatabaseScreen extends StatefulWidget {
  const ConnectDatabaseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConnectDatabaseScreenState();
}

class _ConnectDatabaseScreenState extends State<ConnectDatabaseScreen> {
  String _ip = '';
  String _port = '';
  String _key = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n!.connectDatabase)),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  onChanged: (text) => _ip = text,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.ip,
                  ),
                ),
                TextField(
                  onChanged: (text) => _port = text,
                  decoration: InputDecoration(
                    labelText: l10n.port,
                  ),
                ),
                TextField(
                  onChanged: (text) => _key = text,
                  decoration: InputDecoration(
                    labelText: l10n.key,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_ip.isEmpty || _port.isEmpty || _key.isEmpty) return;

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
