import '../app_config/app_endpoints.dart';
import 'index.dart';

class CaseService {

  getSubmittedCases(dynamic, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetSubmittedCases';
    var response = await connection.post(url, requestModel);
    return response;
  }
}