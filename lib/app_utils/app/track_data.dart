import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prop_edge/app_services/local_db/db/database_services.dart';
import 'package:path/path.dart';
import 'package:prop_edge/app_utils/alert_service2.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:sqflite/sqflite.dart';

class FFTrackData extends StatefulWidget {
  const FFTrackData({super.key});

  @override
  State<FFTrackData> createState() => _FFTrackDataState();
}

class _FFTrackDataState extends State<FFTrackData> {
  String _dbPath = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDatabasePath();
  }

  Future<void> _loadDatabasePath() async {
    try {
      final db = await DatabaseServices.instance.database;
      final path = db.path;
      setState(() {
        _dbPath = path;
        debugPrint('----> db path $_dbPath');
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading database path: $e');
    }
  }

  Future<void> _deleteDatabaseFile() async {
    if (_dbPath.isEmpty) {
      // AlertService.showErrorAlert(
      //     context, "Error", "Database path not loaded.");
      AlertService().errorToast('Database path not loaded.');
      return;
    }

    try {
      DatabaseServices.instance.clearDatabase;
      AlertService().successToast('DB deleted successfully.');
      setState(() {
        _dbPath = '';
      });
    } catch (e) {
      // AlertService.showErrorAlert(
      //     context, "Error", "Failed to delete database: $e");
      AlertService().errorToast('Failed to delete database: $e');
      debugPrint('Error deleting database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Database Path'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Database Path:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        _dbPath.isNotEmpty ? _dbPath : 'No database found.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _dbPath.isEmpty ? null : _deleteDatabaseFile,
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete Database"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
