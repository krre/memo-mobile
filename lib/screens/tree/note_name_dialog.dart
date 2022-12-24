import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteNameDialog extends StatefulWidget {
  final String name;

  const NoteNameDialog({super.key, this.name = ''});

  @override
  State<StatefulWidget> createState() => NoteNameDialogState();
}

class NoteNameDialogState extends State<NoteNameDialog> {
  String _name = '';
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n!.name),
      content: TextField(
        onChanged: (value) => _name = value,
        controller: _controller,
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
