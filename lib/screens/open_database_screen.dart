import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memo/screens/tree/tree_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../db/database.dart';

class OpenDatabaseScreen extends StatefulWidget {
  const OpenDatabaseScreen({super.key});

  @override
  State<OpenDatabaseScreen> createState() => _OpenDatabaseScreenState();
}

class _OpenDatabaseScreenState extends State<OpenDatabaseScreen> {
  final List<String> _databases = [];

  Future<void> loadNames() async {
    var databasesPath = await getDatabasesPath();
    final files = Directory(databasesPath).list();
    _databases.clear();

    await for (final FileSystemEntity file in files) {
      if (file is File && !file.path.contains('.db-journal')) {
        _databases.add(basenameWithoutExtension(file.path));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadNames().then((value) => setState(
          () {},
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.openDatabase)),
      body: ListView.builder(
        itemCount: _databases.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(_databases[index]),
              onTap: () async {
                final navigator = Navigator.of(context);

                await Db.getInstance().open(_databases[index]);

                await navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const TreeScreen();
                }), (r) {
                  return false;
                });
              });
        },
      ),
    );
  }
}
