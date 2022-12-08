import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectDatabaseScreen extends StatefulWidget {
  const ConnectDatabaseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConnectDatabaseScreenState();
}

class _ConnectDatabaseScreenState extends State<ConnectDatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.connectDatabase)),
      body: const Center(),
    );
  }
}
