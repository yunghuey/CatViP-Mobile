class APIConstant {
  // change this to your own ipaddress number
  // Stephen's IP
  // static const String URL = "http://10.131.76.30:7015/api/";
  // yung huey IP
  static const String URL = "http://10.131.76.184:7015/api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}Auth/login";
  static String get RefreshURL => "${APIConstant.URL}auth/refresh";
  static String get RegisterURL => "${APIConstant.URL}auth/register";
  static String get ForgotPasswordURL => "${APIConstant.URL}auth/forgot-password";

  // post module

  // expert module
}