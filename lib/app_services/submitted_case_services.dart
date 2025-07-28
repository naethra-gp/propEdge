import '../app_config/app_endpoints.dart';
import 'connection.dart';

class SubmittedCaseServices {
  getSubmittedCases(dynamic, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetSubmittedCases';
    var response = await connection.post(url, requestModel);
    return response;
  }
}
