import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.database),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  debugPrint("create database");
                },
                child: Text(AppLocalizations.of(context)!.create),
              ),
              OutlinedButton(
                onPressed: () {
                  debugPrint("open database");
                },
                child: Text(AppLocalizations.of(context)!.open),
              ),
              OutlinedButton(
                onPressed: () {
                  debugPrint("open to database");
                },
                child: Text(AppLocalizations.of(context)!.connect),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
