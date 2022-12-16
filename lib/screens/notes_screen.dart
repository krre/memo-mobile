import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:memo/screens/notes_drawer.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotesScrenState();
  }
}

class NotesScrenState extends State<NotesScreen> {
  String _newNoteName = '';
  var _treeViewController = TreeViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notes),
        actions: [
          IconButton(
              onPressed: () {
                _showNameDialog();
              },
              icon: const Icon(Icons.add_box_outlined))
        ],
      ),
      body: TreeView(
        controller: _treeViewController,
      ),
      drawer: const NotesDrawer(),
    );
  }

  Future<void> _showNameDialog() async {
    final l10n = AppLocalizations.of(context);
    _newNoteName = '';

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n!.name),
        content: TextField(
          onChanged: (value) => _newNoteName = value,
          autofocus: true,
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                if (_newNoteName.isEmpty) return;

                setState(() {
                  var children = _treeViewController.children.toList();
                  children.add(Node(key: '2', label: _newNoteName));
                  _treeViewController = TreeViewController(children: children);
                });

                Navigator.pop(context);
              },
              child: Text(l10n.ok))
        ],
      ),
    );
  }
}
