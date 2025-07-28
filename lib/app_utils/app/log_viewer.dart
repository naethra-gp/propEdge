import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LogViewerScreen extends StatefulWidget {
  @override
  _LogViewerScreenState createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  String logText = 'Loading logs...';
  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    final log = await readLogFile();
    setState(() {
      logText = log;
    });
  }

  Future<String> readLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/app_log.txt';
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      } else {
        return 'No logs found.';
      }
    } catch (e) {
      return 'Error reading log file: $e';
    }
  }

  Future<void> clearLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/app_log.txt';
      final file = File(path);
      if (await file.exists()) {
        await file.writeAsString('');
        setState(() {
          logText = 'Log cleared.';
        });
      }
    } catch (e) {
      setState(() {
        logText = 'Error clearing log file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('App Logs'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Clear Logs',
            onPressed: () async {
              await clearLogFile();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: SelectableText(logText),
          ),
        ),
      ),
    ));
  }
}
