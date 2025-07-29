import 'package:flutter/material.dart';
import 'package:prop_edge/app_services/local_db/local_services/tracking_service.dart';
import 'package:intl/intl.dart';
import 'package:prop_edge/app_utils/app/app_bar.dart';

class DBTrackData extends StatefulWidget {
  const DBTrackData({super.key});

  @override
  State<DBTrackData> createState() => _DBTrackDataState();
}

class _DBTrackDataState extends State<DBTrackData> {
  final TrackingServices _trackingServices = TrackingServices();
  List<Map<String, dynamic>> _trackingData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrackingData();
    setState(() {});
  }

  Future<void> _loadTrackingData() async {
    try {
      final data = await _trackingServices.read();
      setState(() {
        _trackingData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading tracking data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Location log',
          action: false,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date & Time')),
                      DataColumn(label: Text('Latitude')),
                      DataColumn(label: Text('Longitude')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: _trackingData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(
                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(DateTime.parse(data['Timestamp'])),
                          )),
                          DataCell(Text(data['Latitude'].toString())),
                          DataCell(Text(data['Longitude'].toString())),
                          DataCell(Text(data['TrackStatus'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
