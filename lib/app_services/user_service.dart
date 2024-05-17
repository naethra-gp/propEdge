import '../app_config/index.dart';
import 'connection.dart';

class UserServices {
  /*
  * SERVICE NAME: loginService
  * DESC: User to Login into PROP-EDGE Application
  * METHOD: POST
  * Params: LoginRequestModel
  */

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
