class LoginRequestModel {
  String? userName;
  String? password;
  String? iMEINumber;

  LoginRequestModel({this.userName, this.password, this.iMEINumber});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    password = json['Password'];
    iMEINumber = json['IMEINumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserName'] = userName;
    data['Password'] = password;
    data['IMEINumber'] = iMEINumber;
    return data;
  }
}
