import '../app_config/index.dart';
import 'connection.dart';

class ReimbursementService {
  /// SAVE ONLY WE ARE USED
  saveReimbursement(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/SaveReimbursement';
    var response = await connection.post(url, requestModel);
    return response;
  }

  getReimbursement(context, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetReimbursement';
    var response = await connection.post(url, requestModel);
    return response;
  }

  // deleteReimbursement(context, requestModel) async {
  //   Connection connection = Connection();
  //   var url = '${EndPoints.baseApi}/DeleteReimbursement';
  //   var response = await connection.post(url, requestModel);
  //   return response;
  // }
  //
  // deleteReimbursementBill(context, requestModel) async {
  //   Connection connection = Connection();
  //   var url = '${EndPoints.baseApi}/DeleteReimbursementBill';
  //   var response = await connection.post(url, requestModel);
  //   return response;
  // }
}
