import 'dart:convert';

import 'package:CatViP/model/user/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:CatViP/repository/APIConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository{

  Future<UserModel?> getUser() async {
    try{
      dynamic user_data;
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.viewProfileURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);

        if (response.statusCode == 200){
          var value = response.body;
          var jsonValue = json.decode(value);
          print("receive 200");
          print(jsonValue.toString());
          user_data =  UserModel.fromJson(jsonValue);
          return user_data;
        } else {
          print(response.statusCode);
        }
      }
    } catch (error){
      print('error in get user ');
      print(error.toString());
    }
    return null;
  }
}