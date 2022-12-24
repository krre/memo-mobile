import 'package:flutter/material.dart';

import '../db/database.dart';
import '../globals.dart';

class NoteScreen extends StatefulWidget {
  final Id id;
  const NoteScreen({super.key, required this.id});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  String title = '';

  @override
  void initState() {
    super.initState();
    _setTitle();
  }

  _setTitle() async {
    title = await Db.getInstance().getValue(widget.id, 'title');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(),
    );
  }
}
