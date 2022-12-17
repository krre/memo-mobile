import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:memo/helpers/preferences.dart';
import 'package:memo/screens/tree/tree_drawer.dart';

import '../../db/database.dart';
import '../../globals.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TreeScrenState();
  }
}

class TreeScrenState extends State<TreeScreen> {
  String _newNoteName = '';
  var _treeViewController = TreeViewController();

  void _loadTree() async {
    final path = await Preferences.getDbPath();
    await Db.getInstance().open(path!);

    final titles = await Db.getInstance().getTitles();
    var children = _treeViewController.children.toList();

    for (final title in titles) {
      children.add(
          Node(key: title['id'].toString(), label: title['title'].toString()));
    }

    setState(() {
      _treeViewController = TreeViewController(children: children);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTree();
  }

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
      drawer: const TreeDrawer(),
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
              onPressed: () async {
                if (_newNoteName.isEmpty) return;
                final navigator = Navigator.of(context);

                Id id =
                    await Db.getInstance().insertNote(0, 0, 0, _newNoteName);

                setState(() {
                  var children = _treeViewController.children.toList();
                  children.add(Node(key: id.toString(), label: _newNoteName));
                  _treeViewController = TreeViewController(children: children);
                });

                navigator.pop();
              },
              child: Text(l10n.ok))
        ],
      ),
    );
  }
}
