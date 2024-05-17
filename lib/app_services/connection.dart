import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_config/index.dart';
import '../app_widgets/alert_widget.dart';

class Connection {
  final header = {'Content-Type': 'application/json'};
  AlertService alertService = AlertService();

  // post(ctx, url, requestData) async {
  //   String basicAuth =
  //       'Basic ${base64Encode(utf8.encode("${Constants.basicAuthUsername}:${Constants.basicAuthPassword}"))}';
  //   final header = {
  //     'Content-Type': 'application/json',
  //     'Authorization': basicAuth,
  //   };
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: jsonEncode(requestData),
  //       headers: header,
  //       encoding: Encoding.getByName('utf-8'),
  //     );
  //     final result = jsonDecode(response.body);
  //
  //     if (response.statusCode == 401) {
  //       alertService.hideLoading();
  //       alertService.unAuthorizedAlert(
  //           result['Title'], result['ExceptionMessage']);
  //       return false;
  //     }
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return result;
  //     } else {
  //       alertService.errorToast(result['Title']);
  //       return false;
  //     }
  //   } catch (e) {
  //     // print("Login failed with exception--->$e");
  //     return {"error": "Login failed with exception: $e"};
  //   }
  // }
  //
  // Future<Map<String, dynamic>> postRequest(
  //     ctx, String url, Map<String, dynamic> body) async {
  //   try {
  //     String basicAuth =
  //         'Basic ${base64Encode(utf8.encode("${Constants.basicAuthUsername}:${Constants.basicAuthPassword}"))}';
  //     final header = {
  //       'Content-Type': 'application/json',
  //       'Authorization': basicAuth,
  //     };
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: jsonEncode(body),
  //       headers: header,
  //       encoding: Encoding.getByName('utf-8'),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return json.decode(response.body);
  //     } else {
  //       if (response.statusCode == 401) {
  //         final result = json.decode(response.body);
  //         alertService.hideLoading();
  //         alertService.unAuthorizedAlert(
  //             result['Title'], result['ExceptionMessage']);
  //         // return false;
  //       }
  //       throw Exception(
  //           'Failed to fetch data from $url. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error occurred while fetching data from $url: $e');
  //   }
  // }

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
