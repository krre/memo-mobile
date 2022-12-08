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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (text) {
                  _ip = text;
                  setState(() {});
                },
                autofocus: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.ip,
                ),
              ),
              TextField(
                onChanged: (text) {
                  _port = text;
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.port,
                ),
              ),
              TextField(
                onChanged: (text) {
                  _key = text;
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.key,
                ),
              ),
              OutlinedButton(
                  onPressed:
                      _ip.isNotEmpty && _port.isNotEmpty && _key.isNotEmpty
                          ? () {
                              debugPrint(_ip);
                            }
                          : null,
                  child: const Text("OK"))
            ]),
      ),
    );
  }
}
