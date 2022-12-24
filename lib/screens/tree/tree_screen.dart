import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:memo/helpers/preferences.dart';
import 'package:memo/screens/tree/new_note_dialog.dart';
import 'package:memo/screens/tree/tree_drawer.dart';

import '../../db/database.dart';
import '../../globals.dart';
import '../../widgets/confirm_dialog.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<StatefulWidget> createState() => TreeScrenState();
}

class TreeScrenState extends State<TreeScreen> {
  var _treeViewController = TreeViewController();
  late Offset _tapDownPosition;
  static const _emptyKey = '0';

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

  void _showNodeMenu(BuildContext context) {
    if (_treeViewController.selectedKey == null ||
        _treeViewController.selectedKey == _emptyKey) return;

    final l10n = AppLocalizations.of(context);
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          _tapDownPosition.dx,
          _tapDownPosition.dy,
          overlay.size.width - _tapDownPosition.dx,
          overlay.size.height - _tapDownPosition.dy,
        ),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: Row(children: [const Icon(Icons.delete), Text(l10n!.open)]),
          ),
          PopupMenuItem(
            child: Row(children: [const Icon(Icons.delete), Text(l10n.rename)]),
          ),
          PopupMenuItem(
            onTap: () {
              Future.delayed(const Duration(seconds: 0), () async {
                bool? result = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => ConfirmDialog(
                          title: l10n.deleteNote,
                          description: '',
                        ));

                if (result != null && result) {
                  _deleteNode();
                }
              });
            },
            child: Row(children: [const Icon(Icons.delete), Text(l10n.delete)]),
          )
        ]);
  }

  List<Id> collectChilds(Id parentId) {
    List<Id> result = [];
    result.add(parentId);

    final node = _treeViewController.getNode(parentId.toString())!;

    for (Node child in node.children) {
      result.addAll(collectChilds(int.parse(child.key)));
    }

    return result;
  }

  void _deleteNode() async {
    String key = _treeViewController.selectedKey!;
    List<Id> ids = collectChilds(int.parse(key));

    for (Id id in ids) {
      await Db.getInstance().deleteNote(id);
    }

    final parent = _treeViewController.getParent(key);

    setState(() {
      _treeViewController = _treeViewController.withDeleteNode(key);
    });

    final nodes =
        parent!.key == key ? _treeViewController.children : parent.children;

    nodes.asMap().forEach((index, node) async {
      final id = int.parse(node.key);
      await Db.getInstance().updateValue(id, 'pos', index);
    });
  }

  void _insertNode(String? name) async {
    if (name == null) return;

    final depth = _depth();
    final parentId = _treeViewController.selectedKey != null
        ? int.parse(_treeViewController.selectedKey!)
        : 0;

    Id id = await Db.getInstance().insertNote(parentId, 0, depth, name);

    final node = Node(key: id.toString(), label: name);

    setState(() {
      if (parentId == 0) {
        var children = _treeViewController.children.toList();
        children.add(node);
        _treeViewController = TreeViewController(children: children);
      } else {
        _treeViewController =
            _treeViewController.withAddNode(parentId.toString(), node);
      }

      _treeViewController = _treeViewController.withExpandToNode(id.toString());
      _treeViewController =
          _treeViewController.copyWith(selectedKey: id.toString());
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
                _insertNode(name);
              },
              icon: const Icon(Icons.add_box_outlined))
        ],
      ),
      body: GestureDetector(
        onLongPress: () => _showNodeMenu(context),
        onTapDown: (TapDownDetails details) {
          _tapDownPosition = details.globalPosition;
        },
        onTap: () {
          setState(() {
            _treeViewController =
                _treeViewController.copyWith(selectedKey: _emptyKey);
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
