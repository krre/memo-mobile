import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotesScrenState();
  }
}

Future<void> showNameDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context);

  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n!.name),
      content: const TextField(
        autofocus: true,
      ),
      actions: [ElevatedButton(onPressed: () {}, child: Text(l10n.ok))],
    ),
  );
}

class NotesScrenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notes),
        actions: [
          IconButton(
              onPressed: () => showNameDialog(context),
              icon: const Icon(Icons.add_box_outlined))
        ],
      ),
      body: TreeView(
        controller: TreeViewController(),
      ),
    );
  }
}
