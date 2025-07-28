/*
  * SERVICE NAME: loginService
  * DESC: User to Login into PROP-EDGE Application
  * METHOD: POST
  * Params: LoginRequestModel
  */
import '../app_config/app_endpoints.dart';
import 'connection.dart';

class UserServices {
  loginService(dynamic, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/Login';
    var response = await connection.post(url, requestModel);
    return response;
  }

  logoutService(dynamic, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/Logout';
    var response = await connection.post(url, requestModel);
    return response;
  }
}
