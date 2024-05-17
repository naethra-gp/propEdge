import '../app_config/index.dart';
import 'connection.dart';

class DashboardService {
  getUserSummary(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetUserCaseSummary';
    var response = await connection.post(url, requestModel);
    return response;
  }

  getPropertyList(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetPropertyList';
    var response = await connection.post(url, requestModel);
    return response;
  }
  /// GET PROPERTY DETAIL BASED ON PROP_ID
  getUnAssignProperty( requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetUnassignedProperty';
    var response = await connection.post(url, requestModel);
    return response;
  }
}
