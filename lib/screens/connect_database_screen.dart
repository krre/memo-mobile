import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memo/net/network.dart';

import '../db/database.dart';
import 'tree/tree_screen.dart';

class ConnectDatabaseScreen extends StatefulWidget {
  const ConnectDatabaseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConnectDatabaseScreenState();
}

class _ConnectDatabaseScreenState extends State<ConnectDatabaseScreen> {
  String _ip = '';
  String _port = '';
  String _key = '';
  final _network = Network();

  Future<void> _connectToRemoteDatabase() async {
    _network.ip = _ip;
    _network.port = int.parse(_port);
    _network.key = _key;

    final response = await _network.fetchName();
    await Db.getInstance().create(response['name'], overwrite: true);

    final notes = await _network.fetchNotes();

    for (final note in notes) {
      await Db.getInstance().insertRemoteNote(note['id'], note['parentId'],
          note['pos'], note['depth'], note['title'], note['note']);
    }
  }

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
                    onPressed: () async {
                      if (_ip.isEmpty || _port.isEmpty || _key.isEmpty) return;
                      final navigator = Navigator.of(context);
                      await _connectToRemoteDatabase();

                      navigator.pushAndRemoveUntil(
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
