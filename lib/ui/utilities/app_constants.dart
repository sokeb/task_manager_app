class AppConstants {
  static RegExp emailRegEx = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static RegExp mobileRegEx = RegExp(
  r'/(^(\+88|0088)?(01){1}[3456789]{1}(\d){8})$/'
  );

}
