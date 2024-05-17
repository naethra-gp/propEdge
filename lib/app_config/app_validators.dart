class Validators {

  /// FIELD IS EMPTY THIS ERROR SHOWS
  static isEmpty(String value) {
    if (value.toString().trim().isEmpty) {
      return "Field is Required";
    }
    return null;
  }

}