import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.connectDatabase)),
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
                    labelText: AppLocalizations.of(context)!.ip,
                  ),
                ),
                TextField(
                  onChanged: (text) => _port = text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.port,
                  ),
                ),
                TextField(
                  onChanged: (text) => _key = text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.key,
                  ),
                ),
                ElevatedButton(
                    onPressed: () =>
                        debugPrint('IP $_ip Port $_port Key $_key'),
                    child: const Text('OK'))
              ]),
        ),
      ),
    );
  }
}
