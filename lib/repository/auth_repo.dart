import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository{

  // async for Future<>
  login(String username, String password) async {
    print("test");
    var result;
    try{
       result = await http.post(
        "https://10.131.76.30:7015/api/auth/login" as Uri,
        headers: {
          // "Cache-Control":      "no-cache",
          // "Postman-Token":      "<calculated when request is sent>",
          // "Content-Type":       "application/json",
          // "Content-Length":     "<calculated when request is sent>",
          // "Host" :              "<calculated when request is sent>",
          // "User-Agent" :        "PostmanRuntime/7.34.0",
          // "Accept":             "*/*",
          // "Accept-Encoding":    "gzip, deflate, br",
          // "Connection":         "keep-alive"
        },
        body: {
          "username": "stephen",
          "password": "abc12345",
          "isMobileLogin": true
        },
      );
    } catch (e){
      print(e);
    }

    print("after result");
    print(result.statusCode);
    if (result.statusCode == 200) {
      var data = json.decode(result.body);
      print(data);
      return data;
    } else{
      return "Invalid username or password";
    }
  }
}