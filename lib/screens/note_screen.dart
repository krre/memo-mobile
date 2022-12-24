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
  bool isEditable = false;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();

    _setTitle();
    _setNote();

    setState(() {});
  }

  _setTitle() async {
    title = await Db.getInstance().getValue(widget.id, 'title');
    setState(() {});
  }

  _setNote() async {
    final note = await Db.getInstance().getValue(widget.id, 'note');
    setState(() {});
    _controller = TextEditingController(text: note);
  }

  _updateNote() async {
    await Db.getInstance().updateValue(widget.id, 'note', _controller!.text);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            isEditable
                ? IconButton(
                    onPressed: () async {
                      await _updateNote();
                      isEditable = false;
                      setState(() {});
                    },
                    icon: const Icon(Icons.save))
                : IconButton(
                    onPressed: () {
                      isEditable = true;
                      setState(() {});
                    },
                    icon: const Icon(Icons.edit))
          ],
        ),
        body: isEditable
            ? TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _controller,
              )
            : SelectableText(_controller != null ? _controller!.text : ''));
  }
}
