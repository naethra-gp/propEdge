import '../app_config/app_endpoints.dart';
import 'connection.dart';

class SiteVisitService {
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
  getUnAssignProperty(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetUnassignedProperty';
    var response = await connection.post(url, requestModel);
    return response;
  }

  /// GET PROPERTY DETAIL BASED ON PROP_ID
  getPropertyDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/GetPropertyDetails';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE PROPERTY DETAILS - CreatePropertyDetails
  savePropertyDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePropertyDetails';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE AREA DETAILS - CreateAreaDetails
  saveAreaDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateAreaDetails';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE OCCUPANCY DETAILS - CreateOccupancyDetails
  saveOccupancyDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateOccupancyDetails';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE BOUNDARY DETAILS - CreateBoundaryDetails
  saveBoundaryDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateBoundaryDetails';
    var response = await connection.post(url, params);
    return response;
  }
  /// SAVE MEASUREMENT DETAILS - CreateMeasurementSheet
  saveMeasurementDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateMeasurementSheet';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE STAGE CALCULATOR DETAILS - CreateStageCalculator
  saveStageCalculatorDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateStageCalculator';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE COMMENTS DETAILS - CreateCriticalComment
  saveCommentsDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateCriticalComment';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE MEASUREMENT DETAILS - CreateLocationMap
  saveLocationMapDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateLocationMap';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE Property Plan DETAILS - CreatePropertySketch
  savePropertyPlanDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePropertySketch';
    var response = await connection.post(url, params);
    return response;
  }
  /// SAVE PHOTOGRAPH DETAILS - CreatePhotograph
  savePhotographDetails(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePhotograph';
    var response = await connection.post(url, params);
    return response;
  }

  /// SAVE OVERALL SITE VISIT FORM DETAILS - SubmitProperty
  submitProperty(params) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/SubmitProperty';
    var response = await connection.post(url, params);
    return response;
  }

  deleteImageNew(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/DeleteImage';
    var response = await connection.post(url, requestModel);
    return response;
  }

}
