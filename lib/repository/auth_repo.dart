import 'dart:convert';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:http/http.dart' as http;

class AuthRepository{
  Future<bool> login(String username, String password) async {
    try {
      var url = Uri.parse(APIConstant.LoginURL);

      // to serialize the data Map to JSON
      var body = json.encode({
        'username': username,
        'password': password,
        'isMobileLogin' : true
      });

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (response.statusCode == 200) {
        // create a service to store the token in shared preference
        return true;
      }
      
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}