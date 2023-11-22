class APIConstant {
  // change this to your own ipaddress number
  // Stephen's IP
  // static const String URL = "http://10.131.76.30:7015/api/";

  // wafir's IP
  static const String URL = "http://192.168.0.126:7015/api/";

  // yung huey IP
  // static const String URL = "http://10.131.76.184:7015/api/";
  static const String URL = "http://10.131.74.197:7015/api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}Auth/login";
  static String get RefreshURL => "${APIConstant.URL}auth/refresh";
  static String get RegisterURL => "${APIConstant.URL}auth/register";
  static String get ForgotPasswordURL => "${APIConstant.URL}auth/forgot-password";
  static String get LogoutURL => "${APIConstant.URL}auth/logout";

  // post module
  static String get NewPostURL => "${APIConstant.URL}post/createpost";
  static String get GetPostsURL => "${APIConstant.URL}post/getposts";
  //static String get GetPostURL => "${APIConstant.URL}auth/refresh";


  // expert module
}
