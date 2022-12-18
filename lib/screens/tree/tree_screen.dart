import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:memo/helpers/preferences.dart';
import 'package:memo/screens/tree/new_note_dialog.dart';
import 'package:memo/screens/tree/tree_drawer.dart';

import '../../db/database.dart';
import '../../globals.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<StatefulWidget> createState() => TreeScrenState();
}

class TreeScrenState extends State<TreeScreen> {
  var _treeViewController = TreeViewController();

  void _loadTree() async {
    if (!Db.getInstance().isOpen()) {
      final path = await Preferences.getDbPath();
      await Db.getInstance().open(path!);
    }

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
              onPressed: () async {
                final name = await showDialog<String>(
                    context: context,
                    builder: (context) => const NewNoteDialog());

                if (name != null) {
                  Id id = await Db.getInstance().insertNote(0, 0, 0, name);

                  setState(() {
                    var children = _treeViewController.children.toList();
                    children.add(Node(key: id.toString(), label: name));
                    _treeViewController =
                        TreeViewController(children: children);
                  });
                }
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
}
