class APIConstant {
  // change this to your own ipaddress number
  // Stephen's IP
  // static const String URL = "http://10.131.76.30:7015/api/";

  // wafir's IP
  // static const String URL = "http://192.168.0.126:7015/api/";

  // yung huey IP
  // utem
  // static const String URL = "http://192.168.137.1:7015/api/";
  // utem lan
  // static const String URL = "http://10.131.74.197:7015/api/";
  static const String URL = "http://192.168.0.157:7015/api/";


  // auth module
  static String get LoginURL => "${APIConstant.URL}Auth/login";
  static String get RefreshURL => "${APIConstant.URL}auth/refresh";
  static String get RegisterURL => "${APIConstant.URL}auth/register";
  static String get ForgotPasswordURL => "${APIConstant.URL}auth/forgot-password";
  static String get LogoutURL => "${APIConstant.URL}auth/logout";
  static String get viewProfileURL => "${APIConstant.URL}auth/GetUserInfo";
  static String get editProfileURL => "${APIConstant.URL}auth/editProfile-mobile";

  // post module
  static String get NewPostURL => "${APIConstant.URL}post/createpost";
  static String get GetPostsURL => "${APIConstant.URL}post/getposts";
  //static String get GetPostURL => "${APIConstant.URL}auth/refresh";

  // cat module
  static String get NewCatURL => "${APIConstant.URL}cat/StoreCat";
  static String get GetMyCatURL => "${APIConstant.URL}cat/GetCats";

}
