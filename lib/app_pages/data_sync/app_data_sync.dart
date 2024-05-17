import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'widget/master_dropdown_widget.dart';
import 'widget/reimbursement_sync_widget.dart';
import 'widget/site_visit_form_sync_widget.dart';

class DataSyncPage extends StatefulWidget {
  const DataSyncPage({super.key});

  @override
  State<DataSyncPage> createState() => _DataSyncPageState();
}

class _DataSyncPageState extends State<DataSyncPage> {
  bool hasInternet = false;

  StreamSubscription? subscription;

  @override
  void initState() {
    debugPrint("---> Data Sync Page <---");
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    List result0 = await (Connectivity().checkConnectivity());
    if (result0.contains(ConnectivityResult.none)) {
      hasInternet = false;
    } else {
      hasInternet = true;
    }
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        hasInternet = false;
      } else {
        hasInternet = true;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            CustomTheme.defaultSize,
            Text(
              hasInternet ? "You're in Online." : "You're in Offline.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: hasInternet ? Colors.green : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const MasterDropdownWidget(),
            const SizedBox(height: 20),
            const ReimbursementSyncWidget(),
            const SizedBox(height: 20),
            const SiteVisitFormSyncWidget(),
            CustomTheme.defaultSize,
            CustomTheme.defaultSize,
          ],
        ),
      ),
    );
  }
}

// class MyTable extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Table(
//       border: TableBorder.all(),
//       columnWidths: const {
//         0: FixedColumnWidth(100),
//         1: FixedColumnWidth(100),
//         2: FixedColumnWidth(100),
//         3: FixedColumnWidth(100),
//         4: FixedColumnWidth(100),
//         5: FixedColumnWidth(100),
//       },
//       children: List.generate(
//         10,
//         (index) {
//           return TableRow(
//             children: List.generate(
//               6,
//               (colIndex) {
//                 return TableCell(
//                   child: Container(
//                     // height: 40,
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.all(8.0),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Enter value',
//                         fillColor: Colors.grey[200],
//                         filled: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.blue, width: 1.0),
//                           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         // Handle input change
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
