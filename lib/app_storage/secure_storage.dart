import 'package:hive_flutter/hive_flutter.dart';

// Box Storage Class to Store User Details
class BoxStorage {
  var box = Hive.box('PROP_EQUITY_CONTROLS');

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
