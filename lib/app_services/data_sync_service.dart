
import '../app_config/index.dart';
import 'connection.dart';

class DataSyncService {

  /// GET ALL DROPDOWN META DATA VALUES
  getDropdownData(ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetDropdownOptions';
    var response = await connection.post(url, requestModel);
    return response;
  }

  /// GET PROPERTY DETAIL BASED ON PROP_ID
  getPropertyDetails( requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetPropertyDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }



}