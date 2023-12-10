class APIConstant {
  // change this to your own ipaddress number
  // Stephen's IP
  // static const String URL = "http://10.131.76.30:7015/api/";

   //wafir's Melaka IP
   // static const String URL = "http://192.168.0.126:7015/api/";


  // yung huey IP
   //static const String URL = "http://192.168.137.1:7015/api/";
  static const String URL = "http://172.16.88.4:7015/api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}Auth/login";
  static String get RefreshURL => "${APIConstant.URL}auth/refresh";
  static String get RegisterURL => "${APIConstant.URL}auth/register";
  static String get ForgotPasswordURL => "${APIConstant.URL}auth/forgot-password";
  static String get LogoutURL => "${APIConstant.URL}auth/logout";
  static String get viewProfileURL => "${APIConstant.URL}auth/GetUserInfo";
  static String get editProfileURL => "${APIConstant.URL}auth/editProfile-mobile";
  static String get searchUserURL => "${APIConstant.URL}user/SearchUser?Name=";
  static String get getSearchUserInfoURL => "${APIConstant.URL}user/GetSearchUserInfo/";
  static String get followURL => "${APIConstant.URL}user/FollowUser/";
  static String get unfollowURL => "${APIConstant.URL}user/UnfollowUser/";

   // post module
   static String get NewPostURL => "${APIConstant.URL}post/createpost";
   static String get GetPostsURL => "${APIConstant.URL}post/getposts";
   static String get GetOwnPostURL =>  "${APIConstant.URL}post/GetOwnPosts";
   static String get GetCatPostURL =>  "${APIConstant.URL}post/GetCatPosts/";
   static String get GetPostTypesURL => "${APIConstant.URL}post/getposttypes";
   static String get GetPostCommentsURL => "${APIConstant.URL}post/getpostcomments";
   static String get NewCommentURL => "${APIConstant.URL}post/createcomment";
   static String get ActionPostURL => "${APIConstant.URL}post/ActPost";
   static String get DeleteActionPostURL => "${APIConstant.URL}post/deleteactpost/";
   static String get EditPostURL => "${APIConstant.URL}post/editpost/";
   static String get DeletePostURL => "${APIConstant.URL}post/deletepost/";
   static String get SearchUserGetPostURL => "${APIConstant.URL}post/GetPosts/";

   // expert module
   static String get NewExpertURL => "${APIConstant.URL}Expert/ApplyAsExpert";
   static String get GetApplicationURL => "${APIConstant.URL}Expert/GetLastestApplication";
   static String get RevokeApplicationURL => "${APIConstant.URL}Expert/RevokeApplication/";


   // cat module
   static String get NewCatURL => "${APIConstant.URL}cat/StoreCat";
   static String get GetMyCatURL => "${APIConstant.URL}cat/GetCats";
   static String get UpdateCatURL => "${APIConstant.URL}cat/EditCat/";
   static String get DeleteCatURL => "${APIConstant.URL}cat/DeleteCat/";
   static String get GetOneCatURL => "${APIConstant.URL}cat/GetCat/";
   static String get SearchUserAllCatURL => "${APIConstant.URL}cat/GetCats/";

}
