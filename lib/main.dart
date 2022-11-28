import 'package:flutter/material.dart';

void main() {
  runApp(const MemoApp());
}

class MemoApp extends StatelessWidget {
  const MemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Database'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  debugPrint("create database");
                },
                child: const Text("Create"),
              ),
              OutlinedButton(
                onPressed: () {
                  debugPrint("open database");
                },
                child: const Text("Open"),
              ),
              OutlinedButton(
                onPressed: () {
                  debugPrint("open to database");
                },
                child: const Text("Connect"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
