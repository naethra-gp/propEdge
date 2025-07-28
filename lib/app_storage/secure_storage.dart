import 'package:hive_flutter/hive_flutter.dart';

import '../app_config/app_constants.dart';

// Box Storage Class to Store User Details
class BoxStorage {
  var box = Hive.box(Constants.boxStorage);

  save(key, value) {
    box.put(key, value);
  }

  //Get Details Based on Key
  get(key) {
    return box.get(key);
  }

  //Save User Details
  saveUserDetails(user) {
    box.put('user', user);
  }

  //Get User Details
  getUserDetails() {
    return box.get('user');
  }

  //Get User Details
  deleteUserDetails() {
    return box.delete('user');
  }

  //Get User Name
  getLoginToken() {
    var user = getUserDetails();
    return user['LoginToken'].toString();
  }
}
