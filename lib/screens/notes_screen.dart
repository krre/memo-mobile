import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotesScrenState();
  }
}

class NotesScrenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notes)),
      body: const Center(),
    );
  }
}
