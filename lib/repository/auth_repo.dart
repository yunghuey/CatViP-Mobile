import 'dart:convert';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
        print(token);
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
      print('error');
      print(e.toString());
      return false;
    }
  }

  Future<int> register(String username, String fullname, String email, String password, int gender, String bdayDate) async{
    print('inside register');
    var pref = await SharedPreferences.getInstance();
    try{
      bool genderFemale;
      if (gender == 0){ genderFemale = false; }
      else            { genderFemale = true; }

      var url = Uri.parse(APIConstant.RegisterURL);

      var body = json.encode({
        "username": username,
        "fullName": fullname,
        "email": email,
        "password": password,
        "gender": true,
        "dateOfBirth": bdayDate,
        "roleId": 2
      });

      print(body.toString());
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (response.statusCode == 200){
        String data =  response.body;
        pref.setString("token", data);
        return 0;
      }
      else {
        String data =  response.body;
        if(data[0] == 'U'){
          // username duplicated
          return 1;
        } else if (data[0] == 'E') {
        // email duplicated
          return 2;
        }
      }
      return 3;

    } catch (e) {
      print('error in register');
      print(e.toString());
      return 3;
    }
  }

  Future<bool> sendEmail(String email) async{
    print('inside send email');
    try{
      var url = Uri.parse(APIConstant.ForgotPasswordURL + "?email=" + email);
      print(url.toString());
      var response = await http.post(url);

      if (response.statusCode == 200){
        return true;
      } else {
      //   status code == 400
        print('invalid email');
      }
      return false;
    } catch (e){
      print('error in send email for forgot password');
      print(e.toString());
      return false;
    }
  }

  Future<bool> logout() async{
    var pref = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse(APIConstant.LogoutURL);
      String? token = pref.getString('token');

      if (token != null){
        var header = {
          "Content-Type": "application/json",
          'token' : token
        };

        var response = await http.delete(url, headers: header,);

        if (response.statusCode == 200) {
          print('logout success');
          pref.remove("token");
          return true;
        }
      }
      return false;
    } catch (e) {
      print('error in logout');
      print(e.toString());
      return false;
    }
  }
}