import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_config/index.dart';
import '../app_widgets/alert_widget.dart';

class Connection {
  final header = {'Content-Type': 'application/json'};
  AlertService alertService = AlertService();

  post(String url, body) async {
    try {
      /// HEADERS
      String user = Constants.basicAuthUsername;
      String pass = Constants.basicAuthPassword;
      String basicAuth = 'Basic ${base64Encode(utf8.encode("$user:$pass"))}';
      final header = {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      };

      /// API CALLS
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: header,
        encoding: Encoding.getByName('utf-8'),
      );

      /// ERROR HANDLING
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        if (response.statusCode == 401) {
          final result = json.decode(response.body);
          alertService.hideLoading();
          alertService.unAuthorizedAlert(
              result['Title'], result['ExceptionMessage']);
        }
      }
    } catch (e) {
      alertService.errorToast("Error: ${e.toString()}");
    }
  }
}
