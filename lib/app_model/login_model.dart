class LoginRequestModel {
  String? userName;
  String? password;
  String? iMEINumber;
  String? appVersion;
  String? platform;
  String? platformVersion;
  String? latitude;
  String? longitude;

  LoginRequestModel({
    this.userName,
    this.password,
    this.iMEINumber,
    this.appVersion,
    this.platform,
    this.platformVersion,
    this.latitude,
    this.longitude,
  });

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    password = json['Password'];
    iMEINumber = json['IMEINumber'];
    appVersion = json['AppVersion'];
    platform = json['Platform'];
    platformVersion = json['PlatformVersion'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserName'] = userName;
    data['Password'] = password;
    data['IMEINumber'] = iMEINumber;
    data['AppVersion'] = appVersion;
    data['Platform'] = platform;
    data['PlatformVersion'] = platformVersion;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    return data;
  }
}
