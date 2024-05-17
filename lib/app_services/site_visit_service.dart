import 'package:flutter/cupertino.dart';

import '../app_config/app_endpoints.dart';
import 'connection.dart';

class SiteVisitService {

  /// NEW METHOD
  propertyLocation(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePropertyLocationDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }
  locationDetails(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateLocationDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }
  occupancyDetails(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateOccupancyDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }
  feedback(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateFeedback';
    var response = await connection.post(url, requestModel);
    return response;
  }
  boundaryDetails(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateBoundaryDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }
  criticalComment( requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateCriticalComment';
    var response = await connection.post(url, requestModel);
    return response;
  }
  measurementSheet(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateMeasurementSheet';
    var response = await connection.post(url, requestModel);
    return response;
  }
  stageCalculator(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateStageCalculator';
    var response = await connection.post(url, requestModel);
    return response;
  }

  propertySketch(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePropertySketch';
    var response = await connection.post(url, requestModel);
    return response;
  }

  photograph(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePhotograph';
    var response = await connection.post(url, requestModel);
    return response;
  }

  locationMap(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateLocationMap';
    var response = await connection.post(url, requestModel);
    return response;
  }

  deleteImageNew(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/DeleteImage';
    var response = await connection.post(url, requestModel);
    return response;
  }

  submitPropertyNew(requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/SubmitProperty';
    var response = await connection.post(url, requestModel);
    return response;
  }



  // TODO: OLD METHODS
  createPropertyLocationDetails(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePropertyLocationDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createLocationDetails(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateLocationDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createOccupancyDetails(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateOccupancyDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createFeedback(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateFeedback';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createBoundaryDetails(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateBoundaryDetails';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createCriticalComment(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateCriticalComment';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createMeasurementSheet(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateMeasurementSheet';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createStageCalculator(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateStageCalculator';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createPropertySketch(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePropertySketch';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createPhotograph(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreatePhotograph';
    var response = await connection.post(url, requestModel);
    return response;
  }

  createLocationMap(BuildContext ctx, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/CreateLocationMap';
    var response = await connection.post(url, requestModel);
    return response;
  }

  deleteImage(context, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/DeleteImage';
    var response = await connection.post(url, requestModel);
    return response;
  }

  submitProperty(context, requestModel) async {
    Connection connection = Connection();
    var url = '${EndPoints.baseApi}/SubmitProperty';
    var response = await connection.post(url, requestModel);
    return response;
  }
}
