import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewNoteDialog extends StatefulWidget {
  const NewNoteDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewNoteDialogState();
  }
}

class NewNoteDialogState extends State<NewNoteDialog> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n!.name),
      content: TextField(
        onChanged: (value) => _name = value,
        autofocus: true,
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (_name.isNotEmpty) {
                Navigator.pop(context, _name);
              }
            },
            child: Text(l10n.ok))
      ],
    );
  }
}
