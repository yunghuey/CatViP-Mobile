import 'dart:convert';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository{
  Future<bool> login(String username, String password) async {
    var pref = await SharedPreferences.getInstance();
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
          String data =  response.body;
          pref.setString("token", data);
          return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> refreshToken() async{
    print('in refresh token');
    var pref = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse(APIConstant.RefreshURL);
      String? token = pref.getString('token');

      if (token != null){
        print('got token');
        var header = {
          "Content-Type": "application/json",
          'token' : token
        };

        var response = await http.put(url, headers: header,);

        if (response.statusCode == 200) {
          print('status 200');
          String data =  response.body;
          print(data);
          pref.setString("token", data);
          return true;
        } else {
          print('not receiving 200 code');
          return false;
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}