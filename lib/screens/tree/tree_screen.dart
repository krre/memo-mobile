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
      final name = await Preferences.getDbName();
      await Db.getInstance().open(name!);
    }

    final titles = await Db.getInstance().getTitles();
    var children = _treeViewController.children.toList();

    for (final title in titles) {
      final parentId = title['parent_id'].toString();
      final node =
          Node(key: title['id'].toString(), label: title['title'].toString());

      if (parentId == '0') {
        children.add(node);
        _treeViewController = TreeViewController(children: children);
      } else {
        _treeViewController = _treeViewController.withAddNode(parentId, node);
      }
    }

    setState(() {});
  }

  int _depth() {
    if (_treeViewController.selectedKey == null) return 0;
    Node<dynamic>? node = _treeViewController.selectedNode;
    int counter = 0;

    String key = '';

    while (node != null && key != node.key) {
      key = node.key;
      node = _treeViewController.getParent(node.key);

      counter++;
    }

    return counter;
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
        title: FutureBuilder(
            future: Preferences.getDbName(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              return snapshot.data == null
                  ? Text(AppLocalizations.of(context)!.notes)
                  : Text(snapshot.data!);
            }),
        actions: [
          IconButton(
              onPressed: () async {
                final name = await showDialog<String>(
                    context: context,
                    builder: (context) => const NewNoteDialog());

                if (name == null) return;

                final depth = _depth();
                final parentId = _treeViewController.selectedKey != null
                    ? int.parse(_treeViewController.selectedKey!)
                    : 0;

                Id id =
                    await Db.getInstance().insertNote(parentId, 0, depth, name);

                final node = Node(key: id.toString(), label: name);

                setState(() {
                  if (parentId == 0) {
                    var children = _treeViewController.children.toList();
                    children.add(node);
                    _treeViewController =
                        TreeViewController(children: children);
                  } else {
                    _treeViewController = _treeViewController.withAddNode(
                        parentId.toString(), node);
                  }

                  _treeViewController =
                      _treeViewController.withExpandToNode(id.toString());
                  _treeViewController =
                      _treeViewController.copyWith(selectedKey: id.toString());
                });
              },
              icon: const Icon(Icons.add_box_outlined))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _treeViewController =
                _treeViewController.copyWith(selectedKey: "0");
          });
        },
        child: TreeView(
          controller: _treeViewController,
          allowParentSelect: true,
          onNodeTap: (key) {
            setState(() {
              _treeViewController =
                  _treeViewController.copyWith(selectedKey: key);
            });
          },
        ),
      ),
      drawer: const TreeDrawer(),
    );
  }
}
